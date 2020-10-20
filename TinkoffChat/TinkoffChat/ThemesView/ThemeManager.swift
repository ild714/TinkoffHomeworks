//
//  ThemeManager.swift
//  TinkoffChat
//
//  Created by Ildar on 10/7/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ThemeManager: ThemePickerDelegate {
    
    var settingColor = UIColor.white
    var profileColor = UIColor.white
    
    func changeTheme<T>(viewController: T, type: Theme, model: Message? = nil) {
        switch viewController {
        case let viewController as ConversationsListViewController:
            if type == .night {
                changeThemeToNight(viewController: viewController)
            } else {
                changeThemeToClassic(viewController: viewController)
            }
            viewController.tableView.reloadData()
        case let viewController as ProfileViewController:
            if type == .night {
                changeThemeForProfileViewController(viewController: viewController)
            }
        case let viewController as ConversationViewController:
            if type == .night {
                changeThemeForConversationViewController(viewController: viewController)
            }
            
        case let messageConversationTableViewCell as MessageConversationTableViewCell:
             if type == .night {
                changeThemeForMessageConversationTableViewCellNight(cell: messageConversationTableViewCell, model: model ?? nil)
             } else if type == .day {
                changeThemeForMessageConversationTableViewCellDay(cell: messageConversationTableViewCell, model: model ?? nil)
             } else {
                changeThemeForMessageConversationTableViewCellClassic(cell: messageConversationTableViewCell, model: model ?? nil)
            }
        case let themesVC as ThemesViewController:
            if type == .night {
                changeThemeVCNight(viewController: themesVC)
            } else {
                changeThemeVCDay(viewController: themesVC)
            }
        default:
            break
        }
        type.apply()
    }
    
    private func changeThemeVCNight(viewController: ThemesViewController) {
        viewController.navigationController?.navigationBar.barTintColor = .lightGray
    }
    
    private func changeThemeVCDay(viewController: ThemesViewController) {
        viewController.navigationController?.navigationBar.barTintColor = .white
        viewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    private func changeThemeForMessageConversationTableViewCellNight(cell: MessageConversationTableViewCell, model: Message?) {
        cell.messageLabel.textColor = .white
        if let model = model {
            cell.bubbleBackgroundView.backgroundColor = model.senderId == MessagesIdCreator.idUser ?
                UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)
                :
                UIColor(red: 0.361, green: 0.361, blue: 0.361, alpha: 1)
        }
    }

    private func changeThemeForMessageConversationTableViewCellDay(cell: MessageConversationTableViewCell, model: Message?) {
        if let model = model {
            cell.bubbleBackgroundView.backgroundColor = model.senderId == MessagesIdCreator.idUser ? UIColor(red: 223, green: 223, blue: 223)
                :
                UIColor(red: 0.263, green: 0.537, blue: 0.976, alpha: 1)
            cell.messageLabel.textColor = model.senderId == MessagesIdCreator.idUser ? .black : .white
        }
    }

    private func changeThemeForMessageConversationTableViewCellClassic(cell: MessageConversationTableViewCell, model: Message?) {
        if let model = model {
        cell.bubbleBackgroundView.backgroundColor = model.senderId == MessagesIdCreator.idUser ?
            UIColor(red: 223, green: 223, blue: 223)
            :
            UIColor(red: 220, green: 247, blue: 197)
        }
    }

    private func changeThemeForConversationViewController(viewController: ConversationViewController) {
        viewController.view.backgroundColor = UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1)
        viewController.tableView.backgroundColor = .black
    }

    private func changeThemeForProfileViewController(viewController: ProfileViewController) {
                viewController.view.backgroundColor = .black
                viewController.editButton.backgroundColor = .black
                viewController.editButton.setTitleColor(.white, for: .normal)
                viewController.fullName.backgroundColor = .black
                viewController.fullName.textColor = .white
                viewController.labelDetails.backgroundColor = .black
                viewController.labelDetails.textColor = .white
                viewController.saveButton.backgroundColor = UIColor(red: 0.106, green: 0.106, blue: 0.106, alpha: 1)
                viewController.saveButton.setTitleColor(.white, for: .normal)
                viewController.navigationController?.navigationBar.barTintColor = UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1)
    }

    func changeThemeForFooter(viewController: ConversationsListViewController, view: UIView) {
        
        if  Theme.current == .night {
            view.tintColor = UIColor.black
            if let header = view as? UITableViewHeaderFooterView {
                header.textLabel?.textColor = UIColor.white
            }
        } else {
            view.tintColor = UIColor(red: 0.651, green: 0.651, blue: 0.667, alpha: 1)
            if let header = view as? UITableViewHeaderFooterView {
                header.textLabel?.textColor = UIColor.black
            }
        }
    }

    func changeThemeToNight(viewController: ConversationsListViewController) {
        viewController.messageLabelColor = .gray
        viewController.nameLabelColor = .white
        viewController.navigationController?.navigationBar.barTintColor = UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1)
         viewController.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        viewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        viewController.view.backgroundColor = UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1)
        viewController.tableView.backgroundColor = .black
    }

    func changeThemeToClassic(viewController: ConversationsListViewController) {
        viewController.messageLabelColor = .gray
        viewController.nameLabelColor = .black
        viewController.navigationController?.navigationBar.barTintColor = .white
        viewController.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        viewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        viewController.view.backgroundColor = .white
        viewController.tableView.backgroundColor = .white
    }
    
}

enum Theme: Int {
    case `default`
    case classic
    case day
    case night
    
    private enum Keys {
        static let selectedTheme = "SelectedTheme"
    }
    
    static var current: Theme {
        let storedTheme = UserDefaults.standard.integer(forKey: Keys.selectedTheme)
        return Theme(rawValue: storedTheme) ?? .default
    }
    
    func apply() {
        if self == .night {
            UserDefaults.standard.set(self.rawValue, forKey: Keys.selectedTheme)
            UserDefaults.standard.synchronize()
            UITableViewCell.appearance().backgroundColor = .black
            
        } else if self == .day || self == .classic {
            UserDefaults.standard.set(self.rawValue, forKey: Keys.selectedTheme)
            UserDefaults.standard.synchronize()
            UITableViewCell.appearance().backgroundColor = .white
        }
    }
}