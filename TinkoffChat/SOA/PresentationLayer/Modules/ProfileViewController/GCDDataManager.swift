//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Ildar on 10/12/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

enum Type {
    case gcd
    case operation
}

protocol UIMultithreadingDelegate: class {
    func disableButtons()
    func enableButtons()
    func enableTexts()
    func startActivityIndicator()
    func stopActivityIndicator()
    func errorWithReadingFile()
    func errorWithSavingFile()
    func savingSuccess()
    func getSavingData(data: [ProfileDetail]?)
}

class GCDDataManager {
    weak var delegate: UIMultithreadingDelegate?
    let profileData: ProfileData?
    
    init(dataForProfile: [ProfileDetail]) {
        self.profileData = ProfileData(details: dataForProfile)
    }
    
    func writeData() {
        let serialQueue = DispatchQueue(label: "com.writeQueue.serial")
        
        let group = DispatchGroup()
        group.enter()
        delegate?.disableButtons()
        
        serialQueue.async {[weak self] in
            
            self?.profileData?.save()
            
            group.leave()
        }
        group.notify(queue: .main) {[weak self] in
            self?.delegate?.enableButtons()
            self?.delegate?.enableTexts()
            self?.delegate?.stopActivityIndicator()
            self?.delegate?.savingSuccess()
        }
    }
    
    func readData() {
        let serialQueue = DispatchQueue(label: "com.readQueue.serial")
        let group = DispatchGroup()
        
        var savedData: [ProfileDetail]?
        
        group.enter()
        serialQueue.async {[weak self] in

            savedData = self?.profileData?.load()
            group.leave()
        }
        
        group.notify(queue: .main) {[weak self] in
            self?.delegate?.getSavingData(data: savedData)

        }
    }
}
