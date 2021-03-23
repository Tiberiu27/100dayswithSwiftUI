//
//  User+CoreDataClass.swift
//  FriendFaceWithCoreData
//
//  Created by Tiberiu on 17.02.2021.
//
//

import Foundation
import CoreData

enum CodingKeys: CodingKey {
    case age, about, address, company, id, name, isActive
}

@objc(User)
public class User: NSManagedObject, Decodable {

}
