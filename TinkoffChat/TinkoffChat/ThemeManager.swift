//
//  ThemeManager.swift
//  TinkoffChat
//
//  Created by Ildar on 10/7/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

protocol ThemeManagerProtocol {
}

class ThemeManager {
    
    static var settingColor = UIColor.white
    static var profileColor = UIColor.white
    static let defaults = UserDefaults.standard
    
    static func changeTheme<T: ThemeManagerProtocol>(viewController:T,model: MessageCellModel = .init(text: "", isIncoming: false)){
        let savedTypeTheme = defaults.object(forKey: "ThemeType") as? String
        switch viewController {
        case let viewController as ConversationsListViewController:
            if savedTypeTheme == "Night"{
                changeThemeToNight(viewController: viewController)
            } else {
                changeThemeToClassic(viewController: viewController)
            }
            viewController.tableView.reloadData()
        case let viewController as ProfileViewController:
            if savedTypeTheme == "Night"{
                changeThemeForProfileViewController(viewController: viewController)
            }
        case let viewController as ConversationViewController:
            if savedTypeTheme == "Night" {
                changeThemeForConversationViewController(viewController: viewController)
            }
        case let messageConversationTableViewCell as MessageConversationTableViewCell:
             if savedTypeTheme == "Night"{
                changeThemeForMessageConversationTableViewCellNight(cell:messageConversationTableViewCell,model:model)
             } else if savedTypeTheme == "Day" {
                changeThemeForMessageConversationTableViewCellDay(cell:messageConversationTableViewCell,model:model)
             } else {
                changeThemeForMessageConversationTableViewCellClassic(cell:messageConversationTableViewCell,model:model)
            }
        default:
            break
        }
    }
    
    private static func changeThemeForMessageConversationTableViewCellNight(cell:MessageConversationTableViewCell,model:MessageCellModel){
        cell.messageLabel.textColor = .white
        cell.bubbleBackgroundView.backgroundColor = model.isIncoming ? UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1) : UIColor(red: 0.361, green: 0.361, blue: 0.361, alpha: 1)
    }
    
    private static func changeThemeForMessageConversationTableViewCellDay(cell:MessageConversationTableViewCell,model:MessageCellModel){
        cell.bubbleBackgroundView.backgroundColor = model.isIncoming ? UIColor(red: 223, green: 223, blue: 223) : UIColor(red: 0.263, green: 0.537, blue: 0.976, alpha: 1)
        cell.messageLabel.textColor = model.isIncoming ? .black : .white
    }
    
    private static func changeThemeForMessageConversationTableViewCellClassic(cell:MessageConversationTableViewCell,model:MessageCellModel){
        cell.bubbleBackgroundView.backgroundColor = model.isIncoming ? UIColor(red: 223, green: 223, blue: 223) : UIColor(red: 220, green: 247, blue: 197)
    }
    
    private static func changeThemeForConversationViewController(viewController: ConversationViewController){
        viewController.view.backgroundColor = UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1)
        viewController.tableView.backgroundColor = .black
    }
    
    private static func changeThemeForProfileViewController(viewController:ProfileViewController){
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
    
    static func changeThemeForFooter(viewController:ConversationsListViewController,view: UIView){
        if let savedTypeTheme = self.defaults.object(forKey: "ThemeType") as? String{
            if savedTypeTheme == "Night"{
                view.tintColor = UIColor.black
                if let header = view as? UITableViewHeaderFooterView{
                    header.textLabel?.textColor = UIColor.white
                }
            } else {
                view.tintColor = UIColor(red: 0.651, green: 0.651, blue: 0.667, alpha: 1)
                if let header = view as? UITableViewHeaderFooterView{
                    header.textLabel?.textColor = UIColor.black
                }
            }
        }
    }
    
    private static func changeThemeToNight(viewController:ConversationsListViewController) {
        viewController.navigationController?.navigationBar.barTintColor = UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1)
        viewController.settingButton.tintColor = settingColor
        viewController.profileButton.tintColor = profileColor
         viewController.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        viewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        viewController.view.backgroundColor = UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1)
        viewController.tableView.backgroundColor = .black
    }
    
    private static func changeThemeToClassic(viewController:ConversationsListViewController){
        viewController.navigationController?.navigationBar.barTintColor = .white
        viewController.settingButton.tintColor = .black
        viewController.profileButton.tintColor = .black
        viewController.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        viewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        viewController.view.backgroundColor = .white
        viewController.tableView.backgroundColor = .white
    }
    
}

