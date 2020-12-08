//
//  ThemesViewController.swift
//  TinkoffChat
//
//  Created by Ildar on 10/5/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

enum ThemeType: String {
    case none = "Empty"
    case classic = "Classic"
    case day = "Day"
    case night = "Night"
}

class ThemesViewController: UIViewController {
    
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

        let tap = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed(_:)))
        self.view.addGestureRecognizer(tap)
        
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
    
    @objc func longPressed(_ sender: UILongPressGestureRecognizer? = nil) {
        guard let point = sender?.location(in: self.view) else { return }
        let touchAnimation = TouchAnimation()
        touchAnimation.delegate = self
        touchAnimation.showTinkoff(location: point)
    }
    
    @IBAction func classicStyleSelected(_ sender: Any) {
        if typeOfTheme == .none || typeOfTheme == .night || typeOfTheme == .day {
            themeClassicButton.layer.borderWidth = borderWidhtOfButtonTheme
            themeDayButton.layer.borderWidth = 0
            themeNightButton.layer.borderWidth = 0
            typeOfTheme = .classic
            ThemeManager.changeTheme(viewController: self, type: Theme.classic)
        }
    }
    
    @IBAction func dayStyleSelected(_ sender: Any) {
        if typeOfTheme == .none || typeOfTheme == .night || typeOfTheme == .classic {
            themeDayButton.layer.borderWidth = borderWidhtOfButtonTheme
            themeClassicButton.layer.borderWidth = 0
            themeNightButton.layer.borderWidth = 0
            typeOfTheme = .day
            ThemeManager.changeTheme(viewController: self, type: Theme.day)
        }
    }
    
    @IBAction func nightStyleSelected(_ sender: Any) {
        if typeOfTheme == .none || typeOfTheme == .classic || typeOfTheme == .day {
            themeNightButton.layer.borderWidth = borderWidhtOfButtonTheme
            themeClassicButton.layer.borderWidth = 0
            themeDayButton.layer.borderWidth = 0
            typeOfTheme = .night
            ThemeManager.changeTheme(viewController: self, type: Theme.night)
        }
    }
    
    static func storyboardInstance() -> ThemesViewController? {
        let storyboard = UIStoryboard(name: "ThemesViewController", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? ThemesViewController
    }
    
}

// MARK: - TouchAnimationDelegate
extension ThemesViewController: TouchAnimationProtocol {
    func addSublayer(layer: CAEmitterLayer) {
        self.view.layer.addSublayer(layer)
    }
}
