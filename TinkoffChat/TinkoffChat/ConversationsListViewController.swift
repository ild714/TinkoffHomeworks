//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Ildar on 9/27/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit


class ConversationsListViewController: UIViewController,ThemePickerDelegate,ThemeManagerProtocol {
    //1
        func themeViewController(closure: () -> ThemesViewController) {
            let defaults = UserDefaults.standard
            defaults.set(closure().typeOfTheme.rawValue,forKey: "ThemeType")
        }
    
    //2
//    func themeViewController(closure: (ThemeType) -> (), typeOfTheme: ThemeType) {
//        closure(typeOfTheme)
//    }
    
    @IBOutlet weak var settingButton: UIBarButtonItem!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    
    //2
//    let defaults = UserDefaults.standard

    var safeArea: UILayoutGuide!
    let headerTitles = ["Online","History"]
    var peopleSort: [TypesMessages] = []
    
    private let cellIdentifier = String(describing: CustomTableViewCell.self)
    
    lazy var tableView: UITableView = {
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
        
        peopleSort = SortedPeople.returnPeople()
        
        title = "Tinkoff Chat"
    }

    
    @IBAction func showProfileInfo(_ sender: Any) {
        
        if let profileViewController = ProfileViewController.storyboardInstance(){
            let navigationController = UINavigationController()
            navigationController.viewControllers = [profileViewController]
            present(navigationController, animated: true, completion: nil)
        }
    }
    
    @IBAction func showThemesSettings(_ sender: Any) {
        if let themesViewController = ThemesViewController.storyboardInstance(){
            
            navigationController?.pushViewController(themesViewController, animated: true)
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
         ThemeManager().changeTheme(viewController: self, type: Theme.current)
        
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    static func storyboardInstance() -> ConversationsListViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? ConversationsListViewController
    }
}

// MARK: - ConversationsListViewController dataSource methods
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
        
        cell.configure(with:.init(name: person.name, message: person.message, date: person.date, isOnline: person.isOnline, hasUnreadMessages: person.hasUnreadMessages,typeOfMessage: type.type))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
            return headerTitles[section]
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        ThemeManager.changeThemeForFooter(viewController: self,view: view)
    }
    
}

// MARK: - ConversationsListViewController delegate methods
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
