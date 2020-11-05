//
//  ThemesViewController.swift
//  TinkoffChat
//
//  Created by Ildar on 10/5/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

protocol ThemePickerDelegate: class {
    func changeTheme<T>(viewController: T, type: Theme, model: MessageDb?)
}

class ThemesViewController: UIViewController {
    
    var delegate = ThemeManager()
    
    var color = UIColor.green
    var typeOfTheme: Theme = .default
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
        if typeOfTheme == .default || typeOfTheme == .night || typeOfTheme == .day {
            themeClassicButton.layer.borderWidth = borderWidhtOfButtonTheme
            themeDayButton.layer.borderWidth = 0
            themeNightButton.layer.borderWidth = 0
            typeOfTheme = .classic
            delegate.changeTheme(viewController: self, type: typeOfTheme)
        }
    }
    
    @IBAction func dayStyleSelected(_ sender: Any) {
        if typeOfTheme == .default || typeOfTheme == .night || typeOfTheme == .classic {
            themeDayButton.layer.borderWidth = borderWidhtOfButtonTheme
            themeClassicButton.layer.borderWidth = 0
            themeNightButton.layer.borderWidth = 0
            typeOfTheme = .day
            delegate.changeTheme(viewController: self, type: typeOfTheme)
        }
    }
    
    @IBAction func nightStyleSelected(_ sender: Any) {
        if typeOfTheme == .default || typeOfTheme == .classic || typeOfTheme == .day {
            themeNightButton.layer.borderWidth = borderWidhtOfButtonTheme
            themeClassicButton.layer.borderWidth = 0
            themeDayButton.layer.borderWidth = 0
            typeOfTheme = .night
            delegate.changeTheme(viewController: self, type: typeOfTheme)
        }
    }
    
    static func storyboardInstance() -> ThemesViewController? {
        let storyboard = UIStoryboard(name: "ThemesViewController", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? ThemesViewController
    }
    
}
