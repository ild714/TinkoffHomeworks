//
//  ThemeManager.swift
//  TinkoffChat
//
//  Created by Ildar on 10/7/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ThemeManager {
    
    static var settingColor = UIColor.white
    static var profileColor = UIColor.white
    static var themePicker: UIColor {
        if Theme.current == .day || Theme.current == .classic {
            return .white
        } else if Theme.current == .night {
            return .black
        }
        return .white
    }
    
    static func changeTheme<T>(viewController: T, type: Theme, model: MessageDb? = MessageDb() ) {
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

    private static func changeThemeVCNight(viewController: ThemesViewController) {
        viewController.navigationController?.navigationBar.barTintColor = UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1)
    }
    
    private static func changeThemeVCDay(viewController: ThemesViewController) {
        viewController.navigationController?.navigationBar.barTintColor = .white
        viewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }

    private static func changeThemeForMessageConversationTableViewCellNight(cell: MessageConversationTableViewCell, model: MessageDb?) {
        cell.messageLabel.textColor = .white
        if let model = model {
            cell.bubbleBackgroundView.backgroundColor = model.senderId == MessagesIdCreator.idUser ?
                UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)
                :
                UIColor(red: 0.361, green: 0.361, blue: 0.361, alpha: 1)
        }
    }

    private static func changeThemeForMessageConversationTableViewCellDay(cell: MessageConversationTableViewCell, model: MessageDb?) {
        if let model = model {
            cell.bubbleBackgroundView.backgroundColor = model.senderId == MessagesIdCreator.idUser ?
                UIColor(red: 223, green: 223, blue: 223) :
                UIColor(red: 0.263, green: 0.537, blue: 0.976, alpha: 1)
            cell.messageLabel.textColor = model.senderId == MessagesIdCreator.idUser ? .black : .white
        }
    }

    private static func changeThemeForMessageConversationTableViewCellClassic(cell: MessageConversationTableViewCell, model: MessageDb?) {
        if let model = model {
        cell.bubbleBackgroundView.backgroundColor = model.senderId == MessagesIdCreator.idUser ? UIColor(red: 223, green: 223, blue: 223) : UIColor(red: 220, green: 247, blue: 197)
        }
    }

    private static func changeThemeForConversationViewController(viewController: ConversationViewController) {
        viewController.view.backgroundColor = UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1)
        viewController.tableView.backgroundColor = .black
    }

    private static func changeThemeForProfileViewController(viewController: ProfileViewController) {
        viewController.view.backgroundColor = .black
        
        viewController.nameTextField.backgroundColor = .lightGray
        viewController.detailsTextView.backgroundColor = .lightGray
        viewController.detailsTextView.layer.cornerRadius = 5
        viewController.nameTextField.textColor = .black
        viewController.detailsTextView.textColor = .black
        viewController.editButton.backgroundColor = .black
        viewController.editButton.setTitleColor(.none, for: .normal)
        viewController.navigationController?.navigationBar.barTintColor = UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1)
    }

    static func changeThemeForFooter(viewController: ConversationsListViewController, view: UIView) {
        
        if  Theme.current == .night {
            view.tintColor = themePicker
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
    
    private static func changeThemeToNight(viewController: ConversationsListViewController) {

        viewController.navigationController?.navigationBar.barTintColor = UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1)
//        viewController.settingButton.tintColor = settingColor
//        viewController.profileButton.tintColor = profileColor
        viewController.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        viewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        viewController.view.backgroundColor = UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1)
        viewController.tableView.backgroundColor = themePicker
    }

    private static func changeThemeToClassic(viewController: ConversationsListViewController) {
        viewController.navigationController?.navigationBar.barTintColor = .white
        viewController.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        viewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        viewController.view.backgroundColor = themePicker
        viewController.tableView.backgroundColor = themePicker
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
//            UserDefaults.standard.synchronize()
//            UITableViewCell.appearance().backgroundColor = .black
            
//            UINavigationBar.appearance().barTintColor = .lightGray
//            UINavigationBar.appearance().tintColor = .white
//            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//            UINavigationBar.appearance().isTranslucent = false
            
        } else if self == .day || self == .classic {
            UserDefaults.standard.set(self.rawValue, forKey: Keys.selectedTheme)
//            UserDefaults.standard.synchronize()
//            UINavigationBar.appearance().barStyle = .default
//            UITableViewCell.appearance().backgroundColor = .white
        }
    }
}
