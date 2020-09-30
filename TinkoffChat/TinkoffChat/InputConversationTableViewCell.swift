//
//  InputConversationTableViewCell.swift
//  TinkoffChat
//
//  Created by Ildar on 9/29/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit



class InputConversationTableViewCell: UITableViewCell,ConfigurableView {
    
    typealias ConfigurationModel = MessageCellModel
    @IBOutlet weak var inputMessage: UILabel!
    
    func configure(with model: MessageCellModel) {
        self.inputMessage.text = model.text
    }
    
    
}
