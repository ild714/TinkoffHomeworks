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
    var placeholder = "Write profile infromations"
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet{
            imageView.layer.cornerRadius = imageView.bounds.width / 2.0
            imageView.layer.backgroundColor = imageViewColor
        }
    }
    
    @IBOutlet weak var gcdButton: UIButton! {
        didSet{
            gcdButton.layer.backgroundColor = saveButtonColor
            gcdButton.layer.cornerRadius = 14
        }
    }
    @IBOutlet weak var operationButton: UIButton!{
        didSet{
            operationButton.layer.backgroundColor = saveButtonColor
            operationButton.layer.cornerRadius = 14
        }
    }
    
    @IBOutlet weak var initialsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsTextView.delegate = self
        nameTextField.delegate = self
        
        nameTextField.isEnabled = false
        detailsTextView.isEditable = false
        detailsTextView.text = placeholder
        gcdButton.isEnabled = false
        operationButton.isEnabled = false
        
        nameTextField.placeholder = "Name"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        LogsSwitcher.printLogs(function: #function, additionText: "Root view is not visible: ")
        
        initialsLabel.textColor = initialsLabelColor
        self.activityIndicator.isHidden = true

    }
    @IBAction func editPhoto(_ sender: Any) {
        AlertPhoto.showAlertChoosePhoto(viewController: self)
    }
    
    @objc func editTapped() {
        self.nameTextField.isEnabled = true
        self.detailsTextView.isEditable = true
    }
    
    @objc func closeTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func GCDButtonTapped(_ sender: Any) {
        emptyPhoto()
        let gcdReader = GCDDataManager()
        gcdReader.writeData(viewController: self)
    }
    
    @IBAction func OperationButtonTapped(_ sender: Any) {
        emptyPhoto()
        let operations = OperationDataManager()
        if let writeOPeration: ProfileWriteDataOperation = operations.returnOperation(typeOfoperation: .writeOperation) {
            let operationQueue = OperationQueue.main
            writeOPeration.viewController = self
            operationQueue.addOperation(writeOPeration)
        }
    }
    
    static func storyboardInstance() -> ProfileViewController? {
        let storyboard = UIStoryboard(name: "ProfileViewController", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? ProfileViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        LogsSwitcher.printLogs(function: #function, additionText: "Root view is not visible: ")
        
        ThemeManager.changeTheme(viewController: self)
        
        detailsTextView.textColor = .black
        
        //1
        if let gcd: GCDDataManager = MultithreadingDataManager.multithreadPicker(type: .gcd){
            gcd.readData(viewController: self)
        }
        
        //2
//        if let operations: OperationDataManager = MultithreadingDataManager.multithreadPicker(type: .operation){
//            if let readOPeration: ProfileReadDataOperation = operations.returnOperation(typeOfoperation: .readOperation) {
//                let operationQueue = OperationQueue.main
//                readOPeration.viewController = self
//                operationQueue.addOperation(readOPeration)
//            }
//        }
    }
    
    func emptyPhoto(){
        if let _ = self.imageView.image{
             self.initialsLabel.text = ""
        }else {
            if let text = self.nameTextField.text{
                self.initialsLabel.text = text.initialsGetter()
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension ProfileViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        self.initialsLabel.text = ""
        self.imageView.image = image
        
        self.gcdButton.isEnabled = true
        self.operationButton.isEnabled = true
        dismiss(animated: true)
    }
}

// MARK: - UITextViewDelegate
extension ProfileViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray{
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Profile infromations"
            textView.textColor = UIColor.lightGray
            placeholder = ""
        } else {
            placeholder = textView.text
            textView.textColor = .black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholder = textView.text
        gcdButton.isEnabled = true
        operationButton.isEnabled = true
    }

}

// MARK: - UITextFieldDelegate
extension ProfileViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        gcdButton.isEnabled = true
        operationButton.isEnabled = true
    }
}

