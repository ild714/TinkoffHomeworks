//
//  AlertPhoto.swift
//  TinkoffChat
//
//  Created by Ildar on 10/12/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class AlertPhoto {
    static func showAlertChoosePhoto(viewController: ProfileViewController) {
        let alertController = UIAlertController(title: "Edit photo", message: nil, preferredStyle: .actionSheet)
        
        let picker = UIImagePickerController()
        picker.delegate = viewController
        picker.allowsEditing = true
        
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: {[weak viewController] (_) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = UIImagePickerController.SourceType.camera
                viewController?.present(picker, animated: true)
            } else {
                print("Run on real device")
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Photo Gallery", style: .default, handler: { (_) in
            viewController.present(picker, animated: true)
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Download", style: .default, handler: {[weak viewController] (_) in
            if let photoLoaderViewController = viewController?.presentationAssembly?.photoLoaderViewController() {
                let navigationController = UINavigationController()
                photoLoaderViewController.delegate = viewController
                navigationController.viewControllers = [photoLoaderViewController]
                viewController?.present(navigationController, animated: true, completion: nil)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        viewController.present(alertController, animated: true)
    }
}
