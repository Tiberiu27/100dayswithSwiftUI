//
//  Friend+CoreDataProperties.swift
//  FriendFaceWithCoreData
//
//  Created by Tiberiu on 17.02.2021.
//
//

import Foundation
import CoreData


extension Friend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friend> {
        return NSFetchRequest<Friend>(entityName: "Friend")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var friendOf: User?

}

extension Friend : Identifiable {
    
}
