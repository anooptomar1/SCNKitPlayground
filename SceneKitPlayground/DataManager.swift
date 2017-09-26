//
//  DataManager.swift
//  SceneKitPlayground
//
//  Created by Minhung Ling on 2017-09-17.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject {

    static let sharedInstance = DataManager()
    private override init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "FlickrMaze3D")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func generateTileObject() -> TileObject {
        let tile = NSEntityDescription.insertNewObject(forEntityName: "TileObject", into: persistentContainer.viewContext) as! TileObject
        return tile
    }
    
    func generatePlayer() -> PlayerObject {
        let player = NSEntityDescription.insertNewObject(forEntityName: "PlayerObject", into: persistentContainer.viewContext) as! PlayerObject
        return player
    }
    
    func generateTag() -> TagObject {
        let tag = NSEntityDescription.insertNewObject(forEntityName: "TagObject", into: persistentContainer.viewContext) as! TagObject
        return tag
    }
    
    func generateScore() -> ScoreObject {
        let score = NSEntityDescription.insertNewObject(forEntityName: "ScoreObject", into: persistentContainer.viewContext) as! ScoreObject
        return score
    }
    
    func fetchTags() -> [TagObject] {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<TagObject>(entityName: "TagObject")
        do {
            let objectArray = try context.fetch(request)
            return objectArray
        } catch {
            return [TagObject]()
        }
    }
    
    func fetchScores() -> [ScoreObject] {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<ScoreObject>(entityName: "ScoreObject")
        do {
            let objectArray = try context.fetch(request)
            return objectArray
        } catch {
            return [ScoreObject]()
        }
    }

}
