//
//  CustomTableViewCell.swift
//  TinkoffChat
//
//  Created by Ildar on 9/28/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    typealias ConfigurationModel = ChannelData
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            dateLabel.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
        }
    }
    
    func configure(with model: ChannelDb) {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        var dateString: String = ""
        
        if Theme.current == .day || Theme.current == .classic {
            self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            self.nameLabel.textColor = .black
        } else {
            self.backgroundColor = .black
            self.nameLabel.textColor = .white
        }
        
        let dayAgo = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        
        if let lastActivity = model.lastActivity {
            if lastActivity < dayAgo! {
                formatter.dateFormat = "d MMM"
                dateString = formatter.string(from: lastActivity)
            } else {
                formatter.dateFormat = "HH:mm"
                dateString = formatter.string(from: lastActivity)
            }
        }
        
        nameLabel.text = model.name
        if model.lastMessage == ""{
            messageLabel.text = "No messages yet"
            dateLabel.text = ""
            messageLabel.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
        } else {
            messageLabel.text = model.lastMessage
            dateLabel.text = dateString
        }
    }
}
