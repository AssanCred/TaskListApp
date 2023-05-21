//
//  StorageDataManager.swift
//  TaskListApp
//
//  Created by Артём Латушкин on 21.05.2023.
//

import Foundation
import CoreData

final class StorageDataManager {
    
    static let shared = StorageDataManager()
    private var viewContext: NSManagedObjectContext
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskListApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData(completion: @escaping (Result<[Task], Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        do {
            let task = try viewContext.fetch(fetchRequest)
            completion(.success(task))
        } catch {
            completion(.failure(error))
        }
    }
    
    func save(_ taskName: String, completion: @escaping (Task) -> Void) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: viewContext) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: viewContext) as? Task else { return }
        task.title = taskName
        completion(task)
        saveContext()
    }
    
    func delete(task: Task) {
        viewContext.delete(task)
        saveContext()
    }
    
    func edit(task: Task, newTask: String) {
        task.title = newTask
        saveContext()
    }
}
