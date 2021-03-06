//
//  CoreDataStack.swift
//  xPluka
//
//  Created by Peter Arcentales on 12/11/18.
//  Copyright © 2018 Inalambrilk. All rights reserved.
//

import CoreData
import UIKit

struct CoreDataStack{
    
    private let model: NSManagedObjectModel
    internal let coordinator: NSPersistentStoreCoordinator
    private let modelURL: URL
    internal let dbURL: URL
    internal let persistingContext: NSManagedObjectContext
    internal let backgroundContext: NSManagedObjectContext
    let context: NSManagedObjectContext
    
    //It gets the used instance context of the CoreData
    static func shared() -> CoreDataStack
    {
        struct Singleton {
            static var shared = CoreDataStack(modelName: "xPluka")!
        }
        return Singleton.shared
    }
    
    init?(modelName: String)
    {
        //It asumes that the model is installed in the main bundle
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            print("Not Able to find \(modelName) in the main bundle")
            return nil
        }
        self.modelURL = modelURL
        
        //It tries to create the model from the URL
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            print("Not able to create a model from \(modelURL)")
            return nil
        }
        self.model = model
        
        //It creates the store coordinator
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        //It creates a persistingcontext (private queue) and a child one (main queue)
        //It creates a context and connect it to the coordinator
        persistingContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        persistingContext.persistentStoreCoordinator = coordinator
        
        //It creates a context and add connect it to the coordinator
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = persistingContext
        
        //It creates a background context child of main context
        backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.parent = context
        
        //It adds a sqlite store located in the documents folder
        let fm = FileManager.default
        
        guard let docUrl = fm.urls(for: .documentDirectory, in: .userDomainMask).first else
        {
            return nil
        }
        self.dbURL = docUrl.appendingPathComponent("model.sqlite")
        
        //Options for migrations
        let options = [
            NSInferMappingModelAutomaticallyOption: true,
            NSMigratePersistentStoresAutomaticallyOption:true
        ]
        
        do {
            try addStoreCoordinator(NSSQLiteStoreType, configuration: nil, storeURL: dbURL, options: options as [NSObject : AnyObject]?)
        }
        catch {
            print("Not able to add store at \(dbURL)")
        }
    }
    
    func addStoreCoordinator(_ storeType: String, configuration: String?, storeURL: URL, options : [NSObject:AnyObject]?) throws {
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: dbURL, options: nil)
    }
}

internal extension CoreDataStack  {
    
    func dropAllData() throws {
        //In case of migration it deletes the DB (just truncate the tables)
        try coordinator.destroyPersistentStore(at: dbURL, ofType:NSSQLiteStoreType , options: nil)
        try addStoreCoordinator(NSSQLiteStoreType, configuration: nil, storeURL: dbURL, options: nil)
    }
}

extension CoreDataStack {
    
    //It saves the context
    func saveContext() throws {
        context.performAndWait() {
            
            if self.context.hasChanges {
                do {
                    try self.context.save()
                } catch {
                    print("Error while saving main context: \(error)")
                }
                
                // now we save in the background
                self.persistingContext.perform() {
                    do {
                        try self.persistingContext.save()
                    } catch {
                        print("Error while saving persisting context: \(error)")
                    }
                }
            }
        }
    }
    
    //It makes an autosave
    func autoSave(_ delayInSeconds : Int) {
        
        if delayInSeconds > 0 {
            do {
                try saveContext()
                print("Autosaving")
            } catch {
                print("Error while autosaving")
            }
            
            let delayInNanoSeconds = UInt64(delayInSeconds) * NSEC_PER_SEC
            let time = DispatchTime.now() + Double(Int64(delayInNanoSeconds)) / Double(NSEC_PER_SEC)
            
            DispatchQueue.main.asyncAfter(deadline: time) {
                self.autoSave(delayInSeconds)
            }
        }
    }
    
    //It checks if the touristic place was saved
    func fetchTP(_ predicate: NSPredicate, entityName: String) throws -> TouristicPlace?
    {
        let ft = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        ft.predicate = predicate
        guard let tp = (try context.fetch(ft) as! [TouristicPlace]).first else
        {
            return nil
        }
        return tp
    }
    
    //It searches for the photos related to the selected pin
    func fetchPhotos(_ predicate: NSPredicate? = nil, entityName: String, sorting: NSSortDescriptor? = nil) throws -> [Photo]? {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fr.predicate = predicate
        if let sorting = sorting {
            fr.sortDescriptors = [sorting]
        }
        guard let photos = try context.fetch(fr) as? [Photo] else {
            return nil
        }
        return photos
    }
    
    //It locates all the pins which are going to be shown in the map
    func fetchAllTP( entityName: String) throws -> [TouristicPlace]? {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        guard let tps = try context.fetch(fr) as? [TouristicPlace] else {
            return nil
        }
        return tps
    }
    
    //It checks if the touristic place was saved
    func fetchVisit(_ predicate: NSPredicate, entityName: String) throws -> Visit?
    {
        let ft = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        ft.predicate = predicate
        guard let vs = (try context.fetch(ft) as! [Visit]).first else
        {
            return nil
        }
        return vs
    }
    
    //It fetchs all visits
    func fetchAllVisits(entityName: String) throws -> [Visit]?{
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        guard let vs = try context.fetch(fr) as? [Visit] else{
            return nil
        }
        return vs
    }
    
    //Get the last touristicPlace Id
    func getLastTouristicPlaceId() -> String
    {
        var touristicPlaceId:String = ""
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "TouristicPlace")
        fr.sortDescriptors = [NSSortDescriptor(key: "tpCreationDate", ascending: false)]
        var tp: TouristicPlace?
        do {
            try tp = (try context.fetch(fr) as! [TouristicPlace]).first
        } catch {
            
        }
        if(tp == nil)
        {
            touristicPlaceId = "0"
        }
        else
        {
            touristicPlaceId = (tp?.tpId)!
        }
        return touristicPlaceId
    }
    
    //Get the last visitId
    func getLastVisitId() -> String
    {
        var visitId:String = ""
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Visit")
        fr.sortDescriptors = [NSSortDescriptor(key: "vCreationDate", ascending: false)]
        var vs: Visit?
        do {
            try vs = (try context.fetch(fr) as! [Visit]).first
        } catch {
            
        }
        if(vs  == nil)
        {
            visitId = "0"
        }
        else
        {
            visitId = (vs?.vId)!
        }
        return visitId
    }
    
}

