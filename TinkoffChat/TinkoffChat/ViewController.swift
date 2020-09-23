//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Ildar on 9/12/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var labelDetails: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var initialsLabel: UILabel!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //Свойство frame не будет распечатано, так как мы используем storyboard и приложение не производит инициализацию напрямую через даннай класс.
//        print(editButton.frame)
    }
    
    override func viewDidLoad() {
        
        LogsSwitcher.printLogs(function: #function, additionText: "Root view is not visible: ")
        
        imageView.layer.cornerRadius = imageView.bounds.width / 2.0
        imageView.layer.backgroundColor = UIColor(red: 0.894, green: 0.908, blue: 0.17, alpha: 1).cgColor
        
        editButton.setTitleColor(UIColor(red: 0, green: 0.478, blue: 1, alpha: 1), for: .normal)
        
        labelDetails.lineBreakMode = .byWordWrapping
        labelDetails.numberOfLines = 0
        labelDetails.text = "UX/UI designer, web-designer\nMoscow, Russia"
        
        saveButton.layer.backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1).cgColor
        saveButton.layer.cornerRadius = 14

        initialsLabel.textColor = UIColor(red: 0.212, green: 0.216, blue: 0.22, alpha: 1)
        initialsLabel.text = fullName.text.initialsGetter()
        
        print(editButton.frame)
    }
    
    @IBAction func editPhoto(_ sender: Any) {
        let alertController = UIAlertController(title: "What are you planning to do?", message: nil, preferredStyle: .actionSheet)
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        alertController.addAction(UIAlertAction(title: "Choose photo from gallery", style: .default, handler: { (_) in
            self.present(picker,animated: true)
            
        }))
        alertController.addAction(UIAlertAction(title: "Take a picture", style: .default, handler: { (_) in
            picker.sourceType = UIImagePickerController.SourceType.camera
            self.present(picker,animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController,animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        LogsSwitcher.printLogs(function: #function, additionText: "Root view is not visible: ")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        LogsSwitcher.printLogs(function: #function, additionText: "Root view is not visible: ")
        //   Значения отличаются, так как на этапе ViewDidLoad представление не было добавлено в иерахию представлений. Соответственно после вызова viewDidAppear представление добавляется в иерархию и отображает корректные значения для frame.
        print(editButton.frame)
    }
    
    override func viewWillLayoutSubviews() {
        LogsSwitcher.printLogs(function: #function, additionText: "Root view is not visible: ")
    }
    
    override func viewDidLayoutSubviews() {
        LogsSwitcher.printLogs(function: #function, additionText: "Root view is visible: ")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        LogsSwitcher.printLogs(function: #function, additionText: "Root view is visible: ")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        LogsSwitcher.printLogs(function: #function, additionText: "Root view is not visible: ")
    }
}

// MARK: - UIViewController delegate methods
extension ViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        self.initialsLabel.text = ""
        self.imageView.image = image
        
        dismiss(animated: true)
    }
    
}
