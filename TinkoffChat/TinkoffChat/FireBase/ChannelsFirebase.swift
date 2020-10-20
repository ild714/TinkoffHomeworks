//
//  Channels.swift
//  TinkoffChat
//
//  Created by Ildar on 10/18/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import Firebase

class ChannelsFireStore {
    var db: Firestore!
    var channelsArray = [Channel]()
    
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
                        let chanel = Channel(dictionary: document.data(), id: document.documentID)
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
        ref = db.collection("channels").addDocument(data: [
            "name": name,
            "lastMessage": "No recent message"
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with Id: \(ref!.documentID)")
            }
        }
    }
}
