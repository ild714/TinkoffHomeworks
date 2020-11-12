//
//  Channels.swift
//  TinkoffChat
//
//  Created by Ildar on 10/18/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import Firebase

protocol ChannnelFireStoreError: class {
    func showError()
}

protocol ChannelsFireStoreProtocolol {
    var channelsArray: [ChannelData] { get }
    func loadInitiaData(completed: @escaping () -> Void)
    func addChannel(name: String)
}

class ChannelsFireStore: ChannelsFireStoreProtocolol {
    var db: Firestore!
    var channelsArray = [ChannelData]()
    
    weak var delegate: ChannnelFireStoreError?
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadInitiaData(completed: @escaping () -> Void) {
        db.collection("channels").getDocuments { (dataSnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if let dataSnapshot = dataSnapshot {
                    for document in dataSnapshot.documents {
                        let chanel = ChannelData(dictionary: document.data(), id: document.documentID)
                        if let chanel = chanel {
                            self.channelsArray.append(chanel)
                        }
                    }
                }
            }
            completed()
        }
    }
    
    func addChannel(name: String) {
        var ref: DocumentReference?
        if name == ""{
            delegate?.showError()
        } else {
            ref = db.collection("channels").addDocument(data: [
                "name": name,
                "lastMessage": "No recent message"
            ]) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Document added with Id: \(ref?.documentID ?? "No reference to message")")
                }
            }
        }
    }
    
//    func deleteChannel(id: String) {
//
//        db.collection("channels").document("\(id)").delete() { err in
//            if let err = err {
//                print("Error removing document: \(err)")
//            } else {
//                print("Document successfully removed!")
//            }
//        }
//    }
}
