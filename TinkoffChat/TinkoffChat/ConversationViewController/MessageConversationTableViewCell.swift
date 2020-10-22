//
//  MessageConversationTableViewCell.swift
//  TinkoffChat
//
//  Created by Ildar on 9/29/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class MessageConversationTableViewCell: UITableViewCell {
    
    let messageLabel = UILabel()
    let nameMessage = UILabel()
    let bubbleBackgroundView = UIView()
    
    var leadingConstraints: NSLayoutConstraint!
    var trailingConstraints: NSLayoutConstraint!
    var leadingConstraintsName: NSLayoutConstraint!
    var trailingConstraintsName: NSLayoutConstraint!
    var topToNameMessage: NSLayoutConstraint!
    var topToMessageLabel: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        bubbleBackgroundView.layer.cornerRadius = 10
        self.selectionStyle = .none
        
        addSubview(bubbleBackgroundView)
        addSubview(nameMessage)
        addSubview(messageLabel)
//        messageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        messageLabel.numberOfLines = 0
        
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        nameMessage.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            nameMessage.topAnchor.constraint(equalTo: topAnchor, constant: 20),

            messageLabel.topAnchor.constraint(equalTo: nameMessage.bottomAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: (self.frame.size.width / 4) * 2.5 ),
            messageLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 160),
            
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -10),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 10),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        leadingConstraints = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25)
        
        trailingConstraints = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
        leadingConstraintsName = nameMessage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25)
        trailingConstraintsName = nameMessage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
        topToNameMessage = bubbleBackgroundView.topAnchor.constraint(equalTo: nameMessage.topAnchor, constant: -10)
        topToMessageLabel = bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -10)
    }
    
    func configure(with model: Message) {
        
        ThemeManager().changeTheme(viewController: self, type: Theme.current, model: model)
        
        self.messageLabel.text = model.content
        if model.senderId == MessagesIdCreator.idUser {
            trailingConstraints.isActive = true
            leadingConstraints.isActive = false
            trailingConstraintsName.isActive = true
            leadingConstraintsName.isActive = false
            nameMessage.isHidden = true
            topToMessageLabel.isActive = true
        } else {
            topToNameMessage.isActive = true
            nameMessage.text = model.senderName
            leadingConstraints.isActive = true
            trailingConstraints.isActive = false
            trailingConstraintsName.isActive = false
            leadingConstraintsName.isActive = true
        } 
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
