//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Ildar on 9/12/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,ThemeManagerProtocol{
    
    let imageViewColor = UIColor(red: 0.894, green: 0.908, blue: 0.17, alpha: 1).cgColor
    let editButtonColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
    let saveButtonColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1).cgColor
    let initialsLabelColor = UIColor(red: 0.212, green: 0.216, blue: 0.22, alpha: 1)
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet{
            imageView.layer.cornerRadius = imageView.bounds.width / 2.0
            imageView.layer.backgroundColor = imageViewColor
        }
    }
    @IBOutlet weak var editButton: UIButton! {
        didSet{
            editButton.setTitleColor(editButtonColor, for: .normal)
        }
    }
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var labelDetails: UILabel! {
        didSet {
            labelDetails.lineBreakMode = .byWordWrapping
            labelDetails.numberOfLines = 0
            labelDetails.text = "UX/UI designer, web-designer\nMoscow, Russia"
        }
    }
    @IBOutlet weak var saveButton: UIButton! {
        didSet{
            saveButton.layer.backgroundColor = saveButtonColor
            saveButton.layer.cornerRadius = 14
        }
    }
    @IBOutlet weak var initialsLabel: UILabel! {
        didSet{
            initialsLabel.textColor = initialsLabelColor
            let text: String? = "Marina Dudarenko"
            initialsLabel.text = text.initialsGetter()
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //Кнопка инициализируется после загрузки storyboard
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeTapped))
        LogsSwitcher.printLogs(function: #function, additionText: "Root view is not visible: ")
        
        //Frame из выбранного в сториборд устройстве
//        print(editButton.frame)
    }
    
    @objc func closeTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editPhoto(_ sender: Any) {
        let alertController = UIAlertController(title: "Edit photo", message: nil, preferredStyle: .actionSheet)
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in

            if UIImagePickerController.isSourceTypeAvailable(.camera){
                picker.sourceType = UIImagePickerController.SourceType.camera
                self.present(picker,animated: true)
            } else {
                print("Run on real device")
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Photo Gallery", style: .default, handler: { (_) in
            self.present(picker,animated: true)
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController,animated: true)
    }
    
    static func storyboardInstance() -> ProfileViewController? {
        let storyboard = UIStoryboard(name: "ProfileViewController", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? ProfileViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        LogsSwitcher.printLogs(function: #function, additionText: "Root view is not visible: ")
        
        ThemeManager.changeTheme(viewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        LogsSwitcher.printLogs(function: #function, additionText: "Root view is not visible: ")

        //Frame из симулятора
//        print(editButton.frame)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        LogsSwitcher.printLogs(function: #function, additionText: "Root view is not visible: ")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
extension ProfileViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        self.initialsLabel.text = ""
        self.imageView.image = image
        
        dismiss(animated: true)
    }
    
}

