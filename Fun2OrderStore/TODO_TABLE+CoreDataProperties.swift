//
//  TODO_TABLE+CoreDataProperties.swift
//  
//
//  Created by Lo Fang Chou on 2020/9/10.
//
//

import Foundation
import CoreData


extension TODO_TABLE {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TODO_TABLE> {
        return NSFetchRequest<TODO_TABLE>(entityName: "TODO_TABLE")
    }

    @NSManaged public var createTime: Date?
    @NSManaged public var targetTime: Date?
    @NSManaged public var dayString: String?
    @NSManaged public var owner: String?
    @NSManaged public var status: String?
    @NSManaged public var toDoTitle: String?
    @NSManaged public var toDoDetail: String?

}
