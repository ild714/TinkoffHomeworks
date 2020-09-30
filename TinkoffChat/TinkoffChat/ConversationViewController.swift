//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Ildar on 9/28/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

struct MessageCellModel {
    let text: String
    let isIncoming: Bool
}

class ConversationViewController: UIViewController {
    
    var titleName: String? = nil
    let chatMessages = [MessageCellModel(text: "What is the most popular news in Japan?", isIncoming: true),                                     MessageCellModel(text: "Do you know it?", isIncoming: true),
                        MessageCellModel(text:  " Yes, Japan’s new Prime Minister Yoshihide Suga on Tuesday said he wants to “make progress” on peace treaty talks with Russia.", isIncoming: false)
    ]
    
    private let cellIdentifier = String(describing: MessageConversationTableViewCell.self)
    
    private lazy var tableView : UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(MessageConversationTableViewCell.self, forCellReuseIdentifier:cellIdentifier)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.backgroundColor = .white
        return tableView
    }()
    
    override func loadView() {
        super.loadView()
        
       setupTableView()
    }
    
    func setupTableView(){
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        if let titleName = titleName{
            title = titleName
        }
    }
    
    static func storyboardInstance() -> ConversationViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? ConversationViewController
    }

}

extension ConversationViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessageConversationTableViewCell {
            
            let chatMessage = chatMessages[indexPath.row]
            cell.configure(with: .init(text: chatMessage.text, isIncoming: chatMessage.isIncoming))
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}
