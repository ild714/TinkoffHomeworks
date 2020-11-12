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
    var messages = [MessageData]()
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
        
        messagesFireStore.db.collection("channels").document(channelId).collection("messages").addSnapshotListener { (dataSnapshot, error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "error")
                return
            }
            if let dataSnapshot = dataSnapshot {
                self.messages = []
                for document in dataSnapshot.documents {
                    let message = MessageData(dictionary: document.data())
                    if let message = message {
                        self.messages.append(message)
                    }
                }
//                print(self.messages)
                
                self.messagesService?.save(messages: self.messages, id: self.channelId) {
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
    
    @objc func newMessage() {
        let alertController = UIAlertController(title: "Add message", message: nil, preferredStyle: .alert)

        alertController.addTextField { (textField) in
            textField.placeholder = "Message"
        }
        alertController.addAction(UIAlertAction(title: "Create", style: .default, handler: {[weak self] (_) in
            if let text = alertController.textFields?.first?.text {
                if let channelId = self?.channelId {
                    self?.messagesService?.addMessage(message: text, id: channelId)
//                    self?.messagesFireStore.addMessage(message: text, id: channelId)
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
        
        self.messagesService?.load(channelId: self.channelId, completion: { (messages) in
            self.messagesService?.save(messages: messages, id: self.channelId) {
                do {
                    try self.fetchedResultsController?.performFetch()
                    self.tableView.reloadData()
                } catch {
                    print("Fetch failed")
                }
            }
        })
        
        ThemeManager().changeTheme(viewController: self, type: Theme.current)
    }
}

// MARK: - ConversationViewController delegate methods
extension ConversationViewController: UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let channels = fetchedResultsController?.fetchedObjects else {return 0}
        for channelFromDb in channels where self.channelId == channelFromDb.identifier {
//            print(channelFromDb.messages?.count)
            return channelFromDb.messages?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessageConversationTableViewCell {
            
            guard let channels = fetchedResultsController?.fetchedObjects else {return UITableViewCell()}
            for channelFromDb in channels where self.channelId == channelFromDb.identifier {
                
                channelFromDb.messages?.sortedArray(using: [NSSortDescriptor(key: "created", ascending: true)])
                cell.configure(with: channelFromDb.messages?.allObjects[indexPath.row] as? MessageDb)
            }
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
