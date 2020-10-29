//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Ildar on 9/28/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ConversationViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var coreDataStack: CoreDataStack?
    var channelId: String = ""
    var messages = [Message]()
    var titleName: String?
    var db: Firestore!
    var channels = [Channel]()
    
    private let cellIdentifier = String(describing: MessageConversationTableViewCell.self)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(MessageConversationTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.backgroundColor = .white
        return tableView
    }()
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    lazy var messagesFireStore: MessagesFireStore = {
        let channelFireSore = MessagesFireStore()
        channelFireSore.delegate = self
        return channelFireSore
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setupTableView()
        
        if let appDelegate = appDelegate {
            self.coreDataStack = appDelegate.coreDataStack
        }
        
        navigationItem.largeTitleDisplayMode = .never
        
        if let titleName = titleName {
            title = titleName
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(newMessage))
        
        messagesFireStore.db.collection("channels").document(channelId).collection("messages").addSnapshotListener { (dataSnapshot, error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "error")
                return
            }
            if let dataSnapshot = dataSnapshot {
                self.messages = []
                for document in dataSnapshot.documents {
                    let message = Message(dictionary: document.data())
                    if let message = message {
                        self.messages.append(message)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func newMessage() {
        let alertController = UIAlertController(title: "Add message", message: nil, preferredStyle: .alert)

        alertController.addTextField { (textField) in
            textField.placeholder = "Message"
        }
        alertController.addAction(UIAlertAction(title: "Create", style: .default, handler: {[weak self] (_) in
            if let text = alertController.textFields?.first?.text {
                if let channelId = self?.channelId {
                    self?.messagesFireStore.addMessage(message: text, id: channelId)
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
    
    static func storyboardInstance() -> ConversationViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? ConversationViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.app.serial3")
        
        group.enter()
        let db = MessagesFireStore()
        db.loadInitiaData(channelId: channelId) {[weak self] in
            self?.messages = db.messagesArray
            self?.tableView.reloadData()
            group.leave()
        }
        
        group.notify(queue: queue) {
            if let coreDataStack = self.coreDataStack {
                let messagesRequest = MessagesRequest(coreDataStack: coreDataStack)
                messagesRequest.makeRequest(messages: self.messages, id: self.channelId, channels: self.channels)
            }
        }
        
        ThemeManager().changeTheme(viewController: self, type: Theme.current)
    }
}

// MARK: - ConversationViewController delegate methods
extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessageConversationTableViewCell {
            
            let chatMessage = messages[indexPath.row]
            cell.configure(with: chatMessage)
            return cell
        }
        
        return UITableViewCell()
    }
    
}

// MARK: - ConversationViewController delegate methods
extension ConversationViewController: ChannnelFireStoreError {
    func showError() {
        let alertController = UIAlertController(title: "Error", message: "Empty message", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
}
