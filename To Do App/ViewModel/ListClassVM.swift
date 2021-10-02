//
//  ListClassVM.swift
//  To Do App
//
//  Created by Apple on 01/10/21.
//

import Foundation
import UIKit
import CoreData

class ListClassVM{
    var taskListDataArray: [TaskList] = []
    
    func saveDataToDatabase(dataModel: CoreDataBaseModel){
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let task = TaskList(context: context)
        task.task_header = dataModel.title
        task.task_desc = dataModel.listDescription
        task.date = dataModel.date
        task.task_id = Int16(dataModel.id)
        appDelegate.saveContext()
        taskListDataArray.append(task)
    }
    func loadTaskList() -> [TaskList] {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return []
            }
            let context = appDelegate.persistentContainer.viewContext
            let request: NSFetchRequest<TaskList> = TaskList.fetchRequest()
            do {
                let taskData = try context.fetch(request)
                taskListDataArray = taskData
                return taskData
            }  catch {
                fatalError("This was not supposed to happen")
            }
        }
    func loadTodaysList() -> [TaskList]{
        let task = loadTaskList().filter({($0.date?.isToday() ?? Date().isToday())})
        return task
    }
    func loadTomorrowList() -> [TaskList]{
        let task = loadTaskList().filter({($0.date?.isTomorrow() ?? Date().isTomorrow())})
        return task
    }
    func loadOtherDaysList() -> [TaskList]{
        let task = loadTaskList().filter({!($0.date?.isTomorrow() ?? Date().isTomorrow()) && !($0.date?.isToday() ?? Date().isToday())})
        return task
    }
    func deleteTaskFromLost(task: TaskList, completion: @escaping (Bool?) -> ()){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false)
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        context.delete(task)
        appDelegate.saveContext()
        completion(true)
    }
    func getSelectedTask(taskId: Int) -> TaskList?{
        let dataTasks = loadTaskList()
        let task = dataTasks.filter({$0.task_id == Int16(taskId)}).first
        return task
    }
    func updateData(task: TaskList){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "TaskList")
        fetchRequest.predicate = NSPredicate(format: "task_id = %@", task.task_id)
        do
            {
                let test = try managedContext.fetch(fetchRequest)
                let objectUpdate = test[0] as! NSManagedObject
                objectUpdate.setValue(task.task_header, forKey: "task_header")
                objectUpdate.setValue(task.task_desc, forKey: "task_desc")
                objectUpdate.setValue(task.date, forKey: "date")
                do{
                    try managedContext.save()
                }
                catch
                {
                    print(error)
                }
            }
        catch
        {
            print(error)
        }
        
    }
    
    func modifyTask(task: CoreDataBaseModel){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let data = getSelectedTask(taskId: Int(task.id))
        data?.task_id = Int16(task.id)
        data?.task_header = task.title
        data?.task_desc = task.listDescription
        data?.date = task.date
        appDelegate.saveContext()
    }
}
