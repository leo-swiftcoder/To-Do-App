//
//  TaskList+CoreDataProperties.swift
//  To Do App
//
//  Created by Apple on 02/10/21.
//
//

import Foundation
import CoreData


extension TaskList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskList> {
        return NSFetchRequest<TaskList>(entityName: "TaskList")
    }

    @NSManaged public var date: Date?
    @NSManaged public var task_desc: String?
    @NSManaged public var task_header: String?
    @NSManaged public var task_id: Int16

}

extension TaskList : Identifiable {

}
