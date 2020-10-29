//
//  MessagesFirebase.swift
//  TinkoffChat
//
//  Created by Ildar on 10/19/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import Firebase

class MessagesFireStore {
    var db: Firestore!
    var messagesArray = [Message]()
    
    weak var delegate: ChannnelFireStoreError?
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadInitiaData(channelId: String, completed: @escaping () -> Void) {
        db.collection("channels").document(channelId).collection("messages").getDocuments { (dataSnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if let dataSnapshot = dataSnapshot {
                    for document in dataSnapshot.documents {
                        let message = Message(dictionary: document.data())
                        if let message = message {
                            self.messagesArray.append(message)
                        }
                    }
                }
            }
            completed()
        }
    }
    
    func addMessage(message: String, id: String) {
        var ref: DocumentReference?
        if message == ""{
            delegate?.showError()
        } else {
            ref = db.collection("channels").document(id).collection("messages").addDocument(data: [
                "content": message,
                "created": Timestamp(date: Date()),
                "senderName": "Ildar",
                "senderId": MessagesIdCreator.idUser
            ]) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Document added with Id: \(ref?.documentID ?? "No reference to message")")
                }
            }
        }
    }
}
