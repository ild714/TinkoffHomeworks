//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Ildar on 9/27/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {

    var safeArea: UILayoutGuide!
    let headerTitles = ["Online","History"]
    var peopleSort: [TypesMessages] = []
    
    struct TypesMessages {
        let type: String
        let persons: [Person]
    }
    
    struct Person {
        let name: String
        let message: String
        let date: Date
        let isOnline: Bool
        let hasUnreadMessages: Bool
    }
    
    var peoples = [TypesMessages(type: "online", persons: [Person(name: "Morris Henry", message: "Reprehenderit mollit excepteur labore deserunt officia laboris eiusmod cillum eu duis", date: Date(), isOnline: true, hasUnreadMessages: true),Person(name: "Ronald Henry", message: "An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum.", date: Date(), isOnline: true, hasUnreadMessages: false),Person(name: "Grey Henry", message: "", date: Date(), isOnline: true, hasUnreadMessages: true),Person(name: "David Djons", message: "", date: Date(), isOnline: true, hasUnreadMessages: false),Person(name: "Henry Kelvin", message: "Reprehenderit mollit excepteur labore deserunt officia laboris eiusmod cillum eu duis", date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(), isOnline: true, hasUnreadMessages: true),Person(name: "Dan Mark", message: "An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum.", date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(), isOnline: true, hasUnreadMessages: false),Person(name: "Cris Roberson", message: "", date: Date(), isOnline: true, hasUnreadMessages: true),Person(name: "Roberto Carloson", message: "", date: Date(), isOnline: true, hasUnreadMessages: false),Person(name: "Cris Karter", message: "", date: Date(), isOnline: true, hasUnreadMessages: true),Person(name: "Dan Haris", message: "", date: Date(), isOnline: true, hasUnreadMessages: false)]),TypesMessages(type: "offline", persons: [Person(name: "Mark Deik", message: "Dolore veniam Lorem occaecat veniam irure laborum est amet.", date: Date(), isOnline: true, hasUnreadMessages: true),Person(name: "Robert Martin", message: "", date: Date(), isOnline: true, hasUnreadMessages: false),Person(name: "Ben Mark", message: "", date: Date(), isOnline: true, hasUnreadMessages: true),Person(name: "Djon Moris", message: "", date: Date(), isOnline: true, hasUnreadMessages: false),Person(name: "Kris Karter", message: "", date: Date(), isOnline: true, hasUnreadMessages: true),Person(name: "Mike Carloson", message: "Dolore veniam Lorem occaecat veniam irure laborum est amet.", date: Date(), isOnline: true, hasUnreadMessages: false),Person(name: "Daik Hink", message: "", date: Date(), isOnline: true, hasUnreadMessages: true),Person(name: "Mister Harry", message: "", date: Date(), isOnline: true, hasUnreadMessages: false),Person(name: "Vait Djons", message: "Dolore veniam Lorem occaecat veniam irure laborum est amet.", date: Date(), isOnline: true, hasUnreadMessages: true),Person(name: "Morris Robens", message: "", date: Date(), isOnline: true, hasUnreadMessages: false)])]
    
    static func storyboardInstance() -> ConversationsListViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? ConversationsListViewController
    }
    
    private let cellIdentifier = String(describing: CustomTableViewCell.self)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(UINib(nibName: String(describing: CustomTableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func loadView() {
        super.loadView()
        
        safeArea = view.layoutMarginsGuide
        
        setupTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var arrayPersons: [Person] = []
        for typeMessage in peoples {
            if typeMessage.type == "online"{
                peopleSort.append(typeMessage)
            } else {
                for person in typeMessage.persons {
                    
                    if person.message != ""{
                        arrayPersons.append(person)
                    }
                }
                 peopleSort.append(TypesMessages(type: "offline", persons: arrayPersons))
            }
        }
        
        title = "Tinkoff Chat"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    @IBAction func showProfileInfo(_ sender: Any) {
        
        if let viewController = ViewController.storyboardInstance(){
            let navigationController = UINavigationController()
            navigationController.viewControllers = [viewController]
            present(navigationController, animated: true, completion: nil)
        }
    }
    
    
    func setupTableView(){
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
}

extension ConversationsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        peopleSort.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        peopleSort[section].persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = peopleSort[indexPath.section]
        let person = type.persons[indexPath.row]
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with:.init(name: person.name, message: person.message, date: person.date, isOnline: person.isOnline, hasUnreadMessages: person.hasUnreadMessages))
            
        if type.type == "online" {
            cell.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.11, alpha: 0.1)
        } else {
            cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
            return headerTitles[section]
        }
        return nil
    }
    
    
}

extension ConversationsListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = peopleSort[indexPath.section]
        let person = type.persons[indexPath.row]
        
        if let conversationViewController = ConversationViewController.storyboardInstance(){
            conversationViewController.titleName = person.name
            navigationController?.pushViewController(conversationViewController, animated: true)
        }
    }
}
