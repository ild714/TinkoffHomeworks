//
//  SortedPeople.swift
//  TinkoffChat
//
//  Created by Ildar on 10/7/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

struct TypesMessages {
    let type: String
    let persons: [Person]
}

struct Person {
    let name: String
    let message: String
    let date: Date
    let isOnline: Bool
    let hasUnreadMessages: Bool
}

class SortedPeople{
    
    static private var peopleSort: [TypesMessages] = []
    
    static private var peoples = [TypesMessages(type: "online", persons: [Person(name: "Morris Henry", message: "Reprehenderit mollit excepteur labore deserunt officia laboris eiusmod cillum eu duis", date: Date(), isOnline: true, hasUnreadMessages: true),Person(name: "Ronald Henry", message: "An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum.", date: Date(), isOnline: true, hasUnreadMessages: false),Person(name: "Grey Henry", message: "", date: Date(), isOnline: true, hasUnreadMessages: true),Person(name: "David Djons", message: "", date: Date(), isOnline: true, hasUnreadMessages: false),Person(name: "Henry Kelvin", message: "Reprehenderit mollit excepteur labore deserunt officia laboris eiusmod cillum eu duis", date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(), isOnline: true, hasUnreadMessages: true),Person(name: "Dan Mark", message: "An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum.", date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(), isOnline: true, hasUnreadMessages: false),Person(name: "Cris Roberson", message: "", date: Date(), isOnline: true, hasUnreadMessages: true),Person(name: "Roberto Carloson", message: "", date: Date(), isOnline: true, hasUnreadMessages: false),Person(name: "Cris Karter", message: "", date: Date(), isOnline: true, hasUnreadMessages: true),Person(name: "Dan Haris", message: "", date: Date(), isOnline: true, hasUnreadMessages: false)]),TypesMessages(type: "offline", persons: [Person(name: "Mark Deik", message: "Dolore veniam Lorem occaecat veniam irure laborum est amet.", date: Date(), isOnline: true, hasUnreadMessages: true),Person(name: "Robert Martin", message: "", date: Date(), isOnline: true, hasUnreadMessages: false),Person(name: "Ben Mark", message: "", date: Date(), isOnline: true, hasUnreadMessages: true),Person(name: "Djon Moris", message: "", date: Date(), isOnline: true, hasUnreadMessages: false),Person(name: "Kris Karter", message: "", date: Date(), isOnline: true, hasUnreadMessages: true),Person(name: "Mike Carloson", message: "Dolore veniam Lorem occaecat veniam irure laborum est amet.", date: Date(), isOnline: true, hasUnreadMessages: false),Person(name: "Daik Hink", message: "", date: Date(), isOnline: true, hasUnreadMessages: true),Person(name: "Mister Harry", message: "", date: Date(), isOnline: true, hasUnreadMessages: false),Person(name: "Vait Djons", message: "Dolore veniam Lorem occaecat veniam irure laborum est amet.", date: Date(), isOnline: true, hasUnreadMessages: true),Person(name: "Morris Robens", message: "", date: Date(), isOnline: true, hasUnreadMessages: false)])]
    
    
    static private func sortInitialInputMessages(){
        var arrayPersons: [Person] = []
        for typeMessage in peoples {
            if typeMessage.type == "online"{
                peopleSort.append(typeMessage)
            } else {
                for person in typeMessage.persons {
                    
                    if person.message != ""{
                        arrayPersons.append(person)
                    }
                }
                 peopleSort.append(TypesMessages(type: "offline", persons: arrayPersons))
            }
        }
    }
    
    static func returnPeople() -> [TypesMessages]{
        sortInitialInputMessages()
        return peopleSort
    }
    
}

