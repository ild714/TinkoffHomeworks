//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Ildar on 9/27/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ConversationsListViewController: UIViewController {
    
    var nameLabelColor = UIColor(red: 0,green: 0, blue: 0, alpha: 1)
    var messageLabelColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)

    var db: Firestore!
    var safeArea: UILayoutGuide!
    var channels: [Channel] = []
    
    static func storyboardInstance() -> ConversationsListViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? ConversationsListViewController
    }
    
    private let cellIdentifier = String(describing: CustomTableViewCell.self)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(UINib(nibName: String(describing: CustomTableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        safeArea = view.layoutMarginsGuide
        setupTableView()
        
        title = "Channels"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(showThemesSettings))
        let buttonProfile = UIBarButtonItem(image: UIImage(named: "user"), style: .plain, target: self, action: #selector(showProfileInfo))
        let buttonChannels = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(newChannels))
        navigationItem.setRightBarButtonItems([buttonChannels, buttonProfile], animated: true)
        
        db = Firestore.firestore()
        db.collection("channels").addSnapshotListener { (dataSnapshot, error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "error")
                return
            }
            if let dataSnapshot = dataSnapshot {
                self.channels = []
                for document in dataSnapshot.documents {
                    let chanel = Channel(dictionary: document.data(), id: document.documentID)
                    if let chanel = chanel {
                        self.channels.append(chanel)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func showProfileInfo() {
        
        if let profileViewController = ProfileViewController.storyboardInstance() {
            let navigationController = UINavigationController()
            navigationController.viewControllers = [profileViewController]
            present(navigationController, animated: true, completion: nil)
        }
    }
    
    @objc func showThemesSettings(_ sender: Any) {
        if let themesViewController = ThemesViewController.storyboardInstance() {
            
            navigationController?.pushViewController(themesViewController, animated: true)
        }
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ThemeManager().changeTheme(viewController: self, type: Theme.current)
        
        let db = ChannelsFireStore()
        db.loadInitiaData {[weak self] in
            self?.channels = db.channelsArray
            self?.tableView.reloadData()
        }
        
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        ThemeManager().changeThemeForFooter(viewController: self, view: view)
    }
    
    @objc func newChannels() {
        let alertController = UIAlertController(title: "Add channel", message: nil, preferredStyle: .alert)
        let db = ChannelsFireStore()
        alertController.addTextField { (textField) in
            textField.placeholder = "Channel"
        }
        alertController.addAction(UIAlertAction(title: "Create", style: .default, handler: {_ in
            if let text = alertController.textFields?.first?.text {
                db.addChannel(name: text)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
}
   
// MARK: - ConversationsListViewController dataSource methods
extension ConversationsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let channel = channels[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: channel)
        return cell
    }
    
}

// MARK: - ConversationsListViewController delegate methods
extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = channels[indexPath.row]
        
        if let conversationViewController = ConversationViewController.storyboardInstance() {
            conversationViewController.titleName = channel.name
            conversationViewController.channelId = channel.identifier
            navigationController?.pushViewController(conversationViewController, animated: true)
        }
    }
}
