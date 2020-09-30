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
            imageIcon.layer.cornerRadius = imageIcon.bounds.width / 2.0
        }
    }
    
    func configure(with model: Model) {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        var dateString: String = ""
        
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
