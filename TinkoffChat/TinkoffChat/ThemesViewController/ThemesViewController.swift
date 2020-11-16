//
//  ThemesViewController.swift
//  TinkoffChat
//
//  Created by Ildar on 10/5/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit


import UIKit

// Retain cycle может возникнуть в следующем случае:
// ConversationsListViewController держит ThemesViewController, а тот в свою очередь получает замыкание с ConversationsListViewController. В данном случае объекты ссылаются друг на друга.
// 1
protocol ThemePickerDelegate {
    func themeViewController(closure: () -> ThemesViewController)
}

//2
//protocol ThemePickerDelegate {
//    func themeViewController(closure: (ThemeType) -> (),typeOfTheme: ThemeType)
//}
enum ThemeType: String {
    case none = "Empty"
    case classic = "Classic"
    case day = "Day"
    case night = "Night"
}

class ThemesViewController: UIViewController {
    
    //1
    var delegate: ThemePickerDelegate?
    
    //2
//    var delegate: ThemePickerDelegate?
//    var closure: ((ThemeType) -> ())?
    
    var color = UIColor.green
    var typeOfTheme: ThemeType = .none
    private let borderColorOfButtonTheme = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1).cgColor
    private let cornerRadiusOfButtonTheme = CGFloat(14)
    private let borderWidhtOfButtonTheme = CGFloat(3)
    
    @IBOutlet weak var themeClassicButton: UIButton!
    @IBOutlet weak var themeDayButton: UIButton!
    @IBOutlet weak var themeNightButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        themeClassicButton.layer.cornerRadius = cornerRadiusOfButtonTheme
        themeClassicButton.imageView?.layer.cornerRadius = cornerRadiusOfButtonTheme
        themeClassicButton.layer.borderColor = borderColorOfButtonTheme
        
        themeDayButton.layer.cornerRadius = cornerRadiusOfButtonTheme
        themeDayButton.imageView?.layer.cornerRadius = cornerRadiusOfButtonTheme
        themeDayButton.layer.borderColor = borderColorOfButtonTheme
        
        themeNightButton.layer.cornerRadius = cornerRadiusOfButtonTheme
        themeNightButton.imageView?.layer.cornerRadius = cornerRadiusOfButtonTheme
        themeNightButton.layer.borderColor = borderColorOfButtonTheme
        
        title = "Settings"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    @IBAction func classicStyleSelected(_ sender: Any) {
        if typeOfTheme == .none || typeOfTheme == .night || typeOfTheme == .day {
            themeClassicButton.layer.borderWidth = borderWidhtOfButtonTheme
            themeDayButton.layer.borderWidth = 0
            themeNightButton.layer.borderWidth = 0
            typeOfTheme = .classic
            //1
            delegate?.themeViewController(closure: {() in
                return self })
//            2
//            if let closure = closure{
//                delegate?.themeViewController(closure: closure, typeOfTheme: .classic)
//            }
        }
    }
    
    @IBAction func dayStyleSelected(_ sender: Any) {
        if typeOfTheme == .none || typeOfTheme == .night || typeOfTheme == .classic {
            themeDayButton.layer.borderWidth = borderWidhtOfButtonTheme
            themeClassicButton.layer.borderWidth = 0
            themeNightButton.layer.borderWidth = 0
            typeOfTheme = .day
            //1
            delegate?.themeViewController(closure: {() in
                return self })
//            2
//            if let closure = closure{
//                delegate?.themeViewController(closure: closure, typeOfTheme: .day)
//            }
        }
    }
    
    @IBAction func nightStyleSelected(_ sender: Any) {
        if typeOfTheme == .none || typeOfTheme == .classic || typeOfTheme == .day {
            themeNightButton.layer.borderWidth = borderWidhtOfButtonTheme
            themeClassicButton.layer.borderWidth = 0
            themeDayButton.layer.borderWidth = 0
            typeOfTheme = .night
            //1
            delegate?.themeViewController(closure: {() in
                return self })
            //2
//            if let closure = closure{
//                delegate?.themeViewController(closure: closure, typeOfTheme: .night)
//            }
        }
    }
    
    static func storyboardInstance() -> ThemesViewController? {
        let storyboard = UIStoryboard(name: "ThemesViewController", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? ThemesViewController
    }
    
}
