//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Ildar on 10/12/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit


class ProfileWriteDataOperation: Operation{
    
    var viewController: ProfileViewController?
    
    func writeData(viewController: ProfileViewController){
        
        var isProfileChanged = true
        let text = viewController.nameTextField.text
        let details = viewController.detailsTextView.text
        let photo = viewController.imageView.image
        let initials = viewController.initialsLabel.text
        
        DispatchQueue.main.async {
            viewController.gcdButton.isEnabled = false
            viewController.operationButton.isEnabled = false
        }
        
        let fileName = "fileName.txt"
        let fileDetails = "fileDetails.txt"
        let fileImage = "fileImage"
        let fileInitials = "fileInitials.txt"
        
        var namePrevious = ""
        var detailsPrevious = ""
        var imagePrevious: UIImage? = nil
        var initialsPrevious = ""
        if let fileName = self.fileDirectory(file: fileName),
            let fileDetails = self.fileDirectory(file: fileDetails),
            let fileImage = self.fileDirectory(file: fileImage),
            let fileInitials = self.fileDirectory(file: fileInitials){
            
            do{
                namePrevious = try String(contentsOf: fileName, encoding: .utf8)
                detailsPrevious = try String(contentsOf: fileDetails,encoding: .utf8)
                imagePrevious = UIImage(contentsOfFile: fileImage.path)
                initialsPrevious = try String(contentsOf: fileInitials,encoding: .utf8)
            }
            catch {
                print("error with reading files")
            }
        }
        
        if let fileName = self.fileDirectory(file: fileName),
            let fileDetails = self.fileDirectory(file: fileDetails),
            let fileImage = self.fileDirectory(file: fileImage),
            let fileInitials = self.fileDirectory(file: fileInitials){
            do {
                
                var checkPhoto = false
                if let imagePrevious = imagePrevious{
                    if imagePrevious == photo{
                        checkPhoto = true
                    }
                }
                
                if namePrevious == text && detailsPrevious == details && checkPhoto && initialsPrevious == initials  {
                    isProfileChanged = false
                } else {
                    
//                    DispatchQueue.main.async {
//                        ActivityIndicator.startAnimation(viewController: viewController)
//                    }
                    
                    if namePrevious != text{
                        try text?.write(to: fileName, atomically: false, encoding: .utf8)
                    }
                    
                    if detailsPrevious != details{
                        try details?.write(to: fileDetails, atomically: false, encoding: .utf8)
                    }
                    
                    if initialsPrevious != initials{
                        try initials?.write(to: fileInitials,atomically: false,encoding: .utf8)
                    }
                    
                    if let imagePrevious = imagePrevious{
                        if imagePrevious.jpegData(compressionQuality: 1) != photo?.jpegData(compressionQuality: 1) {
                            if let data = photo?.jpegData(compressionQuality: 1) {
                                try data.write(to: fileImage,options: .atomic)
                            }
                        }
                    } else {
                        if let data = photo?.jpegData(compressionQuality: 1) {
                            try data.write(to: fileImage)
                        }
                    }
                }
            }
            catch{
                DispatchQueue.main.async {
//                    let ac = UIAlertController(title: "Данные сохранены", message: "Не удалось сохранить данные", preferredStyle: .alert)
//                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                    ac.addAction(UIAlertAction(title: "Повтороить", style: .default, handler: viewController.GCDButtonTapped(_:)))
//
//                    viewController.present(ac,animated: true)
                }
                print("error with saving file")
            }
        }
        
        DispatchQueue.main.async {
            viewController.gcdButton.isEnabled = true
            viewController.operationButton.isEnabled = true
            
            let ac = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            viewController.nameTextField.isEnabled = false
            viewController.detailsTextView.isEditable = false
//            ActivityIndicator.stopAnimation(viewController: viewController)
            
            if isProfileChanged == false{
                return
            }
            
            viewController.present(ac,animated: true)
        }
    }
    
    func fileDirectory(file: String) -> URL?{
        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            return directory.appendingPathComponent(file)
        } else {
            return nil
        }
    }
    
    override func main(){
        if let viewController = viewController{
            self.writeData(viewController: viewController)
        }
    }
}

class ProfileReadDataOperation: Operation{
    
    var viewController: ProfileViewController?
    
    private func readData(viewController: ProfileViewController){
        let fileName = "fileName.txt"
        let fileDetails = "fileDetails.txt"
        let fileImage = "fileImage"
        let fileInitials = "fileInitials.txt"
        
        var savedName = ""
        var savedDetails = ""
        var savedImage: UIImage?
        var savedInitials = ""
        
        do {
            if let fileName = self.fileDirectory(file: fileName),
                let fileDetails = self.fileDirectory(file: fileDetails),
                let fileImage = self.fileDirectory(file: fileImage),
                let fileInitials = self.fileDirectory(file: fileInitials){
                savedName = try String(contentsOf: fileName, encoding: .utf8)
                savedDetails = try String(contentsOf: fileDetails,encoding: .utf8)
                savedImage = UIImage(contentsOfFile: fileImage.path)
                savedInitials = try String(contentsOf: fileInitials,encoding: .utf8)
            }
        }
        catch {
            print("error with reading file")
        }
        
        DispatchQueue.main.async {
            viewController.nameTextField.text = savedName
            viewController.detailsTextView.text = savedDetails
            viewController.imageView.image = savedImage
            viewController.initialsLabel.text = savedInitials
        }
    }
    
    private func fileDirectory(file: String) -> URL?{
        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            return directory.appendingPathComponent(file)
        } else {
            return nil
        }
    }
    
    override func main(){
        if let viewController = viewController{
            self.readData(viewController: viewController)
        }
    }
}

class OperationDataManager{
    
    enum Operation{
        case readOperation
        case writeOperation
    }
    
    func returnOperation<T>(typeOfoperation: Operation) -> T? {
        if typeOfoperation == .readOperation{
            return ProfileReadDataOperation() as? T
        } else {
            return ProfileWriteDataOperation() as? T
        }
    }
    
}


