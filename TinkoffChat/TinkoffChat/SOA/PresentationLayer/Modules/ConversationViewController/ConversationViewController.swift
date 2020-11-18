//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Ildar on 9/28/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
import FirebaseFirestore
import CoreData

class ConversationViewController: UIViewController {
    
    var messagesService: (MessagesServiceProtocol & MessagesServiceNetworkProtocol)?
    var container: NSPersistentContainer?
    var channelId: String = ""
    var messagesData = [MessageData]()
    var messagesDb = [MessageDb]()
    var titleName: String?
    var fetchedResultsController: NSFetchedResultsController<ChannelDb>?
    
    private let cellIdentifier = String(describing: MessageConversationTableViewCell.self)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(MessageConversationTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        return tableView
    }()
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    fileprivate lazy var fetchedResultsControllerMessage: NSFetchedResultsController<MessageDb>? = {
        let context = self.container?.viewContext
        let request = MessageDb.createFetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        if let context = context {
            let fetchResult = NSFetchedResultsController(fetchRequest: request,
                                                         managedObjectContext: context,
                                                         sectionNameKeyPath: nil,
                                                         cacheName: nil)
            fetchResult.delegate = self
            return fetchResult
        } else {
            return nil
        }
    }()
    
    lazy var messagesFireStore: MessagesFireStore = {
        let channelFireSore = MessagesFireStore()
        channelFireSore.delegate = self
        return channelFireSore
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setupTableView()
        
        navigationItem.largeTitleDisplayMode = .never
        
        if let titleName = titleName {
            title = titleName
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(newMessage))
        
        messagesFireStore.db.collection("channels").document(channelId).collection("messages").addSnapshotListener { [weak self] (dataSnapshot, error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "error")
                return
            }
            if let dataSnapshot = dataSnapshot {
                self?.messagesData = []
                for document in dataSnapshot.documents {
                    let message = MessageData(dictionary: document.data())
                    if let message = message {
                        self?.messagesData.append(message)
                    }
                }
                self?.messagesService?.save(messages: self?.messagesData ?? [], id: self?.channelId ?? "") {
                    self?.performFetch()
                }
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
                    self?.messagesService?.addMessage(message: text, id: channelId)
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
        
        self.messagesService?.load(channelId: self.channelId, completion: {[weak self] (messages) in
            if UserDefaults.standard.integer(forKey: "firstOpen") == self?.channelId.hashValue {
                self?.performFetch()
            } else {
                self?.messagesService?.save(messages: messages, id: self?.channelId ?? "") {
                    self?.performFetch()
                }
            }
        })
        
        ThemeManager.changeTheme(viewController: self, type: Theme.current, model: nil)
    }
    
    func performFetch() {
        do {
            try self.fetchedResultsControllerMessage?.performFetch()
            self.tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        UserDefaults.standard.set(self.channelId.hashValue, forKey: "firstOpen")
    }
    
    func deleteAllMessages(completion: @escaping () -> Void) {
        container?.performBackgroundTask({ (back) in
            do {
                let messages = try back.fetch(MessageDb.createFetchRequest())
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

}

// MARK: - ConversationViewController delegate methods
extension ConversationViewController: UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let messages = fetchedResultsControllerMessage?.fetchedObjects else {return 0}
        
        self.messagesDb.removeAll()

        for message in messages {
            if let channel = message.channel {
                if channel.identifier == self.channelId {
                    self.messagesDb.append(message)
                }
            }
        }
//        messages.map{print($0.channel?.identifier)}
        return self.messagesDb.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessageConversationTableViewCell {
            
            cell.configure(with: messagesDb[indexPath.row])
            
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

// MARK: - NSFetchedResultsControllerDelegate

extension ConversationViewController: NSFetchedResultsControllerDelegate {
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
        @unknown default:
            print("Did not selected case")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("\(#function)")
        self.tableView.endUpdates()
    }
}
