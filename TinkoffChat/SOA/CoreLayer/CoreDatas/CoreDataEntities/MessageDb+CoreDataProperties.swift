//
//  MessageDb+CoreDataProperties.swift
//  
//
//  Created by Ildar on 10/29/20.
//
//

import Foundation
import CoreData

extension MessageDb {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<MessageDb> {
        return NSFetchRequest<MessageDb>(entityName: "MessageDb")
    }

    @NSManaged public var content: String
    @NSManaged public var created: Date
    @NSManaged public var senderId: String
    @NSManaged public var senderName: String
    @NSManaged public var channel: ChannelDb?

}
