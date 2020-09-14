//
//  File.swift
//  Fun2Order
//
//  Created by Lo Fang Chou on 2019/11/19.
//  Copyright © 2019 JStudio. All rights reserved.
//

import Foundation
import UIKit
import CoreData

func insertToDoItem(item: ToDoData) {
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var vc: NSManagedObjectContext!
    
    vc = app.persistentContainer.viewContext

    let toDoData = NSEntityDescription.insertNewObject(forEntityName: "TODO_TABLE", into: vc) as! TODO_TABLE
    toDoData.createTime = item.createTime
    toDoData.targetTime = item.targetTime
    toDoData.dayString = item.dayString
    toDoData.owner = item.owner
    toDoData.status = item.status
    toDoData.toDoTitle = item.toDoTitle
    toDoData.toDoDetail = item.toDoDetail
    
    app.saveContext()
}

func retrieveToDoList(day_string: String) -> [ToDoData] {
    let app = UIApplication.shared.delegate as! AppDelegate
    var vc: NSManagedObjectContext!
    
    vc = app.persistentContainer.viewContext

    var toDoList: [ToDoData] = [ToDoData]()
    
    let fetchSortRequest: NSFetchRequest<TODO_TABLE> = TODO_TABLE.fetchRequest()
    let predicateString = "dayString == \(day_string)"

    let predicate = NSPredicate(format: predicateString)
    fetchSortRequest.predicate = predicate
    let sort = NSSortDescriptor(key: "createTime", ascending: true)
    fetchSortRequest.sortDescriptors = [sort]

    do {
        let todo_list = try vc.fetch(fetchSortRequest)
        for todo_data in todo_list {
            var toDoData: ToDoData = ToDoData()
            toDoData.createTime = todo_data.createTime!
            toDoData.targetTime = todo_data.targetTime!
            toDoData.dayString = todo_data.dayString!
            toDoData.owner = todo_data.owner!
            toDoData.status = todo_data.status!
            toDoData.toDoTitle = todo_data.toDoTitle!
            toDoData.toDoDetail = todo_data.toDoDetail!
            toDoList.append(toDoData)
        }
    } catch {
        print(error.localizedDescription)
    }

    return toDoList
}
