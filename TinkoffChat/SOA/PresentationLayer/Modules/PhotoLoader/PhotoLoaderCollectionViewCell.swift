//
//  PhotoLoaderCollectionViewCell.swift
//  TinkoffChat
//
//  Created by Ildar on 11/16/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class PhotoLoaderCollectionViewCell: UICollectionViewCell {
    
    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var image: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.backgroundColor = .white
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.center.x = self.frame.size.height / 2
        activityIndicator.center.y = self.frame.size.height / 2
        activityIndicator.startAnimating()
        self.addSubview(activityIndicator)
    }
    
    func configure(imageString: String) {
        var imageDataResult: Data?
        if let imageURL = URL(string: imageString) {
            if let imageData = try? Data(contentsOf: imageURL) {
                imageDataResult = imageData
            }
        }
        if let imageDataResult = imageDataResult {
            self.image.image = UIImage(data: imageDataResult)
            self.activityIndicator.stopAnimating()
        }
    }
    
    func returnSelectedImage(imageString: String) -> UIImage? {
        if let imageURL = URL(string: imageString) {
            if let imageData = try? Data(contentsOf: imageURL) {
                return(UIImage(data: imageData))
            }
        }
        return(UIImage())
    }
}
