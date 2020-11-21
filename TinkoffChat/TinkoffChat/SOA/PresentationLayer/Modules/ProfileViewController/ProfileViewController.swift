//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Ildar on 9/12/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var editButtonProfile: UIButton!
    let imageViewColor = UIColor(red: 0.894, green: 0.908, blue: 0.17, alpha: 1).cgColor
    let editButtonColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
    let saveButtonColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1).cgColor
    let initialsLabelColor = UIColor(red: 0.212, green: 0.216, blue: 0.22, alpha: 1)
    var placeholder = "Write profile infromations"
    var gcdDataManager: GCDDataManager?
    var presentationAssembly: PresentationAssemblyProtocol?
    var editSate = true
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = imageView.bounds.width / 2.0
            imageView.layer.backgroundColor = imageViewColor
        }
    }
    
    @IBOutlet weak var gcdButton: UIButton! {
        didSet {
            gcdButton.layer.backgroundColor = saveButtonColor
            gcdButton.layer.cornerRadius = 14
        }
    }
    @IBOutlet weak var operationButton: UIButton! {
        didSet {
            operationButton.layer.backgroundColor = saveButtonColor
            operationButton.layer.cornerRadius = 14
        }
    }
    
    @IBOutlet weak var initialsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed(_:)))
        self.view.addGestureRecognizer(tap)
        
        editButtonProfile.layer.cornerRadius = 10
        detailsTextView.delegate = self
        nameTextField.delegate = self
        
        nameTextField.isEnabled = false
        detailsTextView.isEditable = false
        detailsTextView.text = placeholder
        gcdButton.isEnabled = false
        operationButton.isEnabled = false
        
        nameTextField.placeholder = "Name"
        
        LogsSwitcher.printLogs(function: #function, additionText: "Root view is not visible: ")
        
        initialsLabel.textColor = initialsLabelColor
        self.activityIndicator.isHidden = true

    }
    
    @objc func longPressed(_ sender: UILongPressGestureRecognizer? = nil) {
        guard let point = sender?.location(in: self.view) else { return }
        let touchAnimation = TouchAnimation()
        touchAnimation.delegate = self
        touchAnimation.showTinkoff(location: point)
    }
    
    @IBAction func editPhoto(_ sender: Any) {
        AlertPhoto.showAlertChoosePhoto(viewController: self)
    }
    
    @IBAction func editTapped(_ sender: Any) {
        if editSate == true {
            self.nameTextField.isEnabled = true
            self.detailsTextView.isEditable = true
            self.animation()
            editSate = false
        } else {
            self.nameTextField.isEnabled = false
            self.detailsTextView.isEditable = false
            self.editButtonProfile.layer.removeAllAnimations()
            editSate = true
        }
    }
    
    @IBAction func closeTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func saveDataProfile(_ sender: UIButton) {
        emptyPhoto()
        if sender == self.gcdButton {
            gcdDataManager = GCDDataManager(dataForProfile: [ProfileDetail(
                fileDirectory: "name",
                previous: "",
                typeDocument: .txt,
                text: self.nameTextField.text ?? "",
                image: nil), ProfileDetail(
                    fileDirectory: "details",
                    previous: "",
                    typeDocument: .txt,
                    text: self.detailsTextView.text,
                    image: nil), ProfileDetail(
                        fileDirectory: "image",
                        previous: "",
                        typeDocument: .photo,
                        image: self.imageView.image ?? UIImage()),
                                ProfileDetail(
                                    fileDirectory: "initials", previous: "",
                                    typeDocument: .txt,
                                    text: self.initialsLabel.text,
                                    image: nil)])
            gcdDataManager?.delegate = self
            gcdDataManager?.writeData()
        } else {
            print("error with getting data from UI")
        }
        
    }
    
    static func storyboardInstance() -> ProfileViewController? {
        let storyboard = UIStoryboard(name: "ProfileViewController", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? ProfileViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        LogsSwitcher.printLogs(function: #function, additionText: "Root view is not visible: ")
        
        ThemeManager.changeTheme(viewController: self, type: Theme.current, model: nil)
        
        detailsTextView.textColor = .black
        
        gcdDataManager = GCDDataManager(dataForProfile: [ProfileDetail(
        fileDirectory: "name",
        previous: "",
        typeDocument: .txt,
        text: self.nameTextField.text ?? "",
        image: nil), ProfileDetail(
            fileDirectory: "details",
            previous: "",
            typeDocument: .txt,
            text: self.detailsTextView.text,
            image: nil), ProfileDetail(
                fileDirectory: "image",
                previous: "",
                typeDocument: .photo,
                image: self.imageView.image ?? UIImage()),
                        ProfileDetail(
                            fileDirectory: "initials", previous: "",
                            typeDocument: .txt,
                            text: self.initialsLabel.text,
                            image: nil)])
        gcdDataManager?.delegate = self
        gcdDataManager?.readData()

    }
    
    func emptyPhoto() {
        if self.imageView.image != nil {
             self.initialsLabel.text = ""
        } else {
            if let text = self.nameTextField.text {
                self.initialsLabel.text = text.initialsGetter()
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        self.initialsLabel.text = ""
        self.imageView.image = image
        
        self.gcdButton.isEnabled = true
        self.operationButton.isEnabled = true
        dismiss(animated: true)
    }

}

// MARK: - UITextViewDelegate
extension ProfileViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
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
extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        gcdButton.isEnabled = true
        operationButton.isEnabled = true
    }
}

// MARK: - UIMultithreadingDelegate
extension ProfileViewController: UIMultithreadingDelegate {
    func getSavingData(data: [ProfileDetail]?) {
        if let data = data {
            for detail in data {
                if detail.fileDirectory == "name"{
                    self.nameTextField.text = detail.text
                } else if detail.fileDirectory == "details"{
                    self.detailsTextView.text = detail.text
                } else if detail.fileDirectory == "image"{
                    self.imageView.image = detail.image
                } else {
                    self.initialsLabel.text = detail.text
                }
            }
        } else {
            let ac = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные или извлечь данные", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ac, animated: true)
        }
    }
    
    func savingSuccess() {
        let ac = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(ac, animated: true)
    }
    
    func enableTexts() {
        self.nameTextField.isEnabled = false
        self.detailsTextView.isEditable = false
    }
    
    func errorWithSavingFile() {
        let ac = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        ac.addAction(UIAlertAction(title: "Повтороить", style: .default, handler: {_ in
            self.saveDataProfile(self.gcdButton)
        }))
        
        self.present(ac, animated: true)
    }
    
    func errorWithReadingFile() {
        let ac = UIAlertController(title: "Ошибка", message: "Не удалось считать данные с диска", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(ac, animated: true)
    }
    
    func stopActivityIndicator() {
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    func startActivityIndicator() {
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
    }
    
    func disableButtons() {
        self.gcdButton.isEnabled = false
        self.operationButton.isEnabled = false
    }
    
    func enableButtons() {
        self.gcdButton.isEnabled = true
        self.operationButton.isEnabled = true
    }
}

// MARK: - PhotoLoaderViewControllerDelegate
extension ProfileViewController: PhotoLoaderViewControllerDelegate {
    func update(photo: UIImage) {
        self.imageView.image = photo
        self.gcdButton.isEnabled = true
        self.operationButton.isEnabled = true
    }
}
 
// MARK: - Animations
extension ProfileViewController {
    func animation() {
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [.repeat, .allowUserInteraction, .autoreverse], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.15) {
                        self.editButtonProfile.transform = CGAffineTransform(rotationAngle: CGFloat(-0.31))
                    }
                    UIView.addKeyframe(withRelativeStartTime: 0.15, relativeDuration: 0.15) {
                       self.editButtonProfile.transform = CGAffineTransform(rotationAngle: CGFloat(0.31))
                    }
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.05) {
                        self.editButtonProfile.transform = CGAffineTransform(translationX: 5, y: 0)
                    }
                    UIView.addKeyframe(withRelativeStartTime: 0.05, relativeDuration: 0.05) {
                       self.editButtonProfile.transform = CGAffineTransform(translationX: -5, y: 0)
                    }
                    UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.1) {
                        self.editButtonProfile.transform = CGAffineTransform(translationX: 0, y: 5)
                    }
                    UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.1) {
                     self.editButtonProfile.transform = CGAffineTransform(translationX: 0, y: -5)
                    }
        
                }, completion: nil)
    }
}

// MARK: - TouchAnimationDelegate
extension ProfileViewController: TouchAnimationProtocol {
    func addSublayer(layer: CAEmitterLayer) {
        self.view.layer.addSublayer(layer)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension ProfileViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(animationDuration: 3.5, animationType: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(animationDuration: 3.5, animationType: .dismiss)
    }
}
