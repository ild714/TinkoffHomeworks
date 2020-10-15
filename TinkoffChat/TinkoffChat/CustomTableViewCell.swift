//
//  CustomTableViewCell.swift
//  TinkoffChat
//
//  Created by Ildar on 9/28/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

protocol ConfigurableView {
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
}

struct Model {
    let name: String
    let message: String
    let date: Date
    let isOnline: Bool
    let hasUnreadMessages: Bool
    let typeOfMessage: String
}

class CustomTableViewCell: UITableViewCell,ConfigurableView {
    typealias ConfigurationModel = Model
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!{
        didSet{
            dateLabel.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
        }
    }
    @IBOutlet weak var imageIcon: UIImageView!{
        didSet{
            print(imageIcon.bounds.width / 2.0)
            imageIcon.layer.cornerRadius = imageIcon.bounds.width / 2.0
        }
    }
    
    func configure(with model: Model) {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        var dateString: String = ""
        
        if Theme.current == .day || Theme.current == .classic {
            if model.typeOfMessage == "online" {
                self.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.11, alpha: 0.1)
            } else {
                self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            }
        } else {
            self.backgroundColor = .black
        }
        
        let dayAgo = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        if model.date < dayAgo! {
            formatter.dateFormat = "d MMM"
            dateString = formatter.string(from: model.date)
        } else {
            formatter.dateFormat = "HH:mm"
            dateString = formatter.string(from: model.date)
        }
        
        nameLabel.text = model.name
        if model.message == ""{
            messageLabel.text = "No messages yet"
            dateLabel.text = ""
            messageLabel.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
        } else if model.hasUnreadMessages == true{
            messageLabel.font = UIFont.boldSystemFont(ofSize: 13)
            messageLabel.text = model.message
            dateLabel.text = dateString
        } else {
            messageLabel.text = model.message
            dateLabel.text = dateString
        }
        
    }
}
