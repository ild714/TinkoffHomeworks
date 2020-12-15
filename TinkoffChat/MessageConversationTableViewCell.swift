//
//  MessageConversationTableViewCell.swift
//  TinkoffChat
//
//  Created by Ildar on 9/29/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class MessageConversationTableViewCell: UITableViewCell, ConfigurableView {

    let messageLabel = UILabel()
    let bubbleBackgroundView = UIView()
    
    var leadingConstraints: NSLayoutConstraint!
    var trailingConstraints: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        bubbleBackgroundView.layer.cornerRadius = 10
        self.selectionStyle = .none
        
        addSubview(bubbleBackgroundView)
        addSubview(messageLabel)
        messageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        messageLabel.numberOfLines = 0
        
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: (self.bounds.width / 4.0) * 2.5),
            
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -10),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 10),
            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -10),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        leadingConstraints = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25)
        trailingConstraints = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
        
    }
    
    func configure(with model: MessageCellModel) {
        
        ThemeManager.changeTheme(viewController: self, type: Theme.current, model: model)
        
        self.messageLabel.text = model.text
        
        if model.isIncoming {
            leadingConstraints.isActive = true
            trailingConstraints.isActive = false
            
        } else {
            trailingConstraints.isActive = true
            leadingConstraints.isActive = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
