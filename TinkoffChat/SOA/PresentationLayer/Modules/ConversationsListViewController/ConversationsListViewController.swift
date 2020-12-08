//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Ildar on 9/27/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
import FirebaseFirestore
import CoreData

protocol ConversationsListViewControllerDelegate: class {
    func saveDataToCoreData(channels: [ChannelData])
}

class ConversationsListViewController: UIViewController {
    
    var channelsService: (ChannelServiceNetworkProtocol & ChannelServiceStorageProtocol)?
    var presentationAssembly: PresentationAssemblyProtocol?
    
    var container: NSPersistentContainer?
    var safeArea: UILayoutGuide!
    var channels: [ChannelData] = []
    var fetchResult: NSFetchedResultsController<ChannelDb>?
    
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
    
    lazy var channelFireStore: ChannelsFireStore = {
        let channelFireSore = ChannelsFireStore()
        channelFireSore.delegate = self
        return channelFireSore
    }()
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<ChannelDb>? = {
        let context = self.container?.viewContext
        let request = ChannelDb.createFetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        if let context = context {
            fetchResult = NSFetchedResultsController(fetchRequest: request,
                                                         managedObjectContext: context,
                                                         sectionNameKeyPath: nil,
                                                         cacheName: nil)
            fetchResult?.delegate = self
            return fetchResult
        } else {
            return nil
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed(_:)))
        self.tableView.addGestureRecognizer(tap)
        
        title = "Channels"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(showThemesSettings))
        let buttonProfile = UIBarButtonItem(image: UIImage(named: "user"), style: .plain, target: self, action: #selector(showProfileInfo))
        let buttonChannels = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(newChannels))
        navigationItem.setRightBarButtonItems([buttonChannels, buttonProfile], animated: true)
        
        channelFireStore.db.collection("channels").addSnapshotListener { (dataSnapshot, error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "error")
                return
            }
            if let dataSnapshot = dataSnapshot {
                self.channels = []
                for document in dataSnapshot.documents {
                    let chanel = ChannelData(dictionary: document.data(), id: document.documentID)
                    if let chanel = chanel {
                        self.channels.append(chanel)
                    }
                }
                self.channelsService?.save(channels: self.channels) {
                    do {
                        try self.fetchedResultsController?.performFetch()
                        self.tableView.reloadData()
                    } catch {
                        print("Fetch failed")
                    }
                }
            }
        }
    }
    
    @objc func longPressed(_ sender: UILongPressGestureRecognizer? = nil) {
        guard let point = sender?.location(in: self.tableView) else { return }
        let touchAnimation = TouchAnimation()
        touchAnimation.delegate = self
        touchAnimation.showTinkoff(location: point)
    }
    
    @objc func showProfileInfo() {
        
        if let profileViewController = ProfileViewController.storyboardInstance() {
            profileViewController.presentationAssembly = self.presentationAssembly
            profileViewController.modalPresentationStyle = .custom
            profileViewController.transitioningDelegate = profileViewController
            present(profileViewController, animated: true, completion: nil)
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
        safeArea = view.layoutMarginsGuide
        
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        ThemeManager.changeTheme(viewController: self, type: Theme.current, model: nil)
        
        do {
            try self.fetchedResultsController?.performFetch()
            self.tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
        
        self.channelsService?.load(completion: {[weak self] (channels) in
            if UserDefaults.standard.bool(forKey: "firstChannelOpen") != false {
                self?.channelsService?.save(channels: channels) {
                    self?.performFetch()
                }
            } else {
                self?.performFetch()
            }
        })

        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        UserDefaults.standard.set(false, forKey: "firstChannelOpen")
    }
        
    func deleteAllChannels(completion: @escaping () -> Void) {
        container?.performBackgroundTask({ (back) in
            do {
                let messages = try back.fetch(ChannelDb.createFetchRequest())
                for message in messages {
                    back.delete(message as NSManagedObject)
                }
                do {
                    try back.save()
                } catch {
                    print("error with saving")
                }
                completion()
            } catch {
                print("error with fetch")
            }
        })
    }
    
    func performFetch() {
        do {
            try self.fetchedResultsController?.performFetch()
            self.tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        ThemeManager.changeThemeForFooter(viewController: self, view: view)
    }
    
    @objc func newChannels() {
        let alertController = UIAlertController(title: "Add channel", message: nil, preferredStyle: .alert)

        alertController.addTextField { (textField) in
            textField.placeholder = "Channel"
        }
        alertController.addAction(UIAlertAction(title: "Create", style: .default, handler: {[weak self] _ in
            if let text = alertController.textFields?.first?.text {
                self?.channelsService?.addChannel(name: text)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
}
   
// MARK: - ConversationsListViewController dataSource methods
extension ConversationsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let channels = fetchedResultsController?.fetchedObjects else {return 0}
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        if let channel = fetchedResultsController?.object(at: indexPath) {
        
        cell.configure(with: channel)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        if editingStyle == .delete {
            guard let channel = fetchedResultsController?.object(at: indexPath) else { return }
            if let container = container {
                container.viewContext.delete(channel)
                if container.viewContext.hasChanges {
                    do {
                        try container.viewContext.save()
                    } catch {
                        print("An error occured while saving: \(error)")
                    }
                }
            }
        }
    }
}

// MARK: - ConversationsListViewController delegate methods
extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = fetchedResultsController?.object(at: indexPath)
        if let conversationViewController = presentationAssembly?.conversationViewController() {
            conversationViewController.container = self.container
            conversationViewController.titleName = channel?.name
            conversationViewController.channelId = channel?.identifier ?? ""
            conversationViewController.fetchedResultsController = self.fetchResult
            navigationController?.pushViewController(conversationViewController, animated: true)
        }
    }
}

// MARK: - ChannnelFireStoreError delegate methods
extension ConversationsListViewController: ChannnelFireStoreError {
    func showError() {
        let alertController = UIAlertController(title: "Error", message: "Empty channel", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("\(#function)")
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            print("\(#function) -type: Insert")
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            } else {
                print("error with indexPath")
            }
        case .move:
            print("\(#function) -type: move")
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.insertRows(at: [indexPath], with: .automatic)
            } else {
                print("error with indexPath")
            }
        case .update:
            print("\(#function) -type: update")
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                print("error with indexPath")
            }
        case .delete:
            print("\(#function) -type: delete")
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                print("error with indexPath")
            }
        default:
           break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("\(#function)")
        self.tableView.endUpdates()
    }
}

// MARK: - TouchAnimationDelegate
extension ConversationsListViewController: TouchAnimationProtocol {
    func addSublayer(layer: CAEmitterLayer) {
        self.tableView.layer.addSublayer(layer)
    }
}
