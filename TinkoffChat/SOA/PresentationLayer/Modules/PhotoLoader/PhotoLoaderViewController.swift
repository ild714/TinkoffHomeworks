//
//  PhotoLoaderViewController.swift
//  TinkoffChat
//
//  Created by Ildar on 11/16/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

protocol PhotoLoaderViewControllerDelegate: class {
    func update(photo: UIImage)
}

class PhotoLoaderViewController: UIViewController {

    var safeArea: UILayoutGuide?
    var model: ImagesModel?
    var images: [ImageModel]?
    var activityIndicator = UIActivityIndicatorView()
    weak var delegate: PhotoLoaderViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        model?.delegate = self
        model?.fetchImages()
        setupTableView()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeTapped))
    }
    
    func setupTableView() {
        view.addSubview(collectionView)
        
        safeArea = view.layoutMarginsGuide
        if let safeArea = safeArea {
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        }
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.center.x = self.view.bounds.width / 2
        activityIndicator.center.y = self.view.bounds.height / 2
        activityIndicator.startAnimating()
        collectionView.addSubview(activityIndicator)
    }
    
    let cellIdentifier = String(describing: PhotoLoaderCollectionViewCell.self)
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UINib(nibName: String(describing: PhotoLoaderCollectionViewCell.self), bundle: nil ), forCellWithReuseIdentifier: cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    @objc func closeTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    static func storyboardInstance() -> PhotoLoaderViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? PhotoLoaderViewController
    }
}

// MARK: - UICollectionViewDataSource
extension PhotoLoaderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? PhotoLoaderCollectionViewCell {
            if let images = images {
                cell.configure(imageString: images[indexPath.row].previewURL)
                return cell
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? PhotoLoaderCollectionViewCell {
            if let images = images {
                if let result = cell.returnSelectedImage(imageString: images[indexPath.row].previewURL) {
                    self.delegate?.update(photo: result)
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotoLoaderViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size.width
        return CGSize(width: collectionViewSize / 3.5, height: collectionViewSize / 3.5)
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 10
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
}

// MARK: - ImageModelDelegate
extension PhotoLoaderViewController: ImageModelDelegate {
    func setup(dataSource: [ImageModel]) {
        self.images = dataSource
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    func show(error message: String) {
        print(message)
    }
}
