//
//  CoreDataStack.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/11/25.
//

import CloudKit
import CoreData
import Foundation

actor CoreDataStack: ObservableObject {
    let container: NSPersistentCloudKitContainer
    var viewContext: NSManagedObjectContext
    
    init(inMemory: Bool = false) {
//        let transformers = [ArrayOfIntTransformer(), ArrayOfStringTransformer(), ImageDataTransformer(),
//                            SetOfIntTransformer(), SetOfStringTransformer()]
//        for transformer in transformers {
//            ValueTransformer.setValueTransformer(transformer,
//                                                 forName: NSValueTransformerName(String(describing: type(of: transformer))))
//        }
        
        let container = NSPersistentCloudKitContainer(name: "Finova")
        self.container = container
        viewContext = container.viewContext
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        guard let applicationSupportDirectory = try? FileManager.default.url(for: .applicationSupportDirectory,
                                                                             in: .userDomainMask,
                                                                             appropriateFor: nil,
                                                                             create: true) else {
//            CrashlyticsService.shared.record(areaOfCrash: #function, customMessage: "Can't create the the applicationSupportDirectory")
            return
        }
        
        let localStoreUrl = applicationSupportDirectory.appending(path: "local.sqlite")
        let localStoreDescription = NSPersistentStoreDescription(url: localStoreUrl)
        localStoreDescription.configuration = "Local"
        
        //        let cloudStoreUrl = applicationSupportDirectory.appending(path: "cloud.sqlite")
        //        let cloudStoreDescription = NSPersistentStoreDescription(url: cloudStoreUrl)
        //        cloudStoreDescription.configuration = "Cloud"
        //        cloudStoreDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.dev.mobitech.moodmate")
        //        cloudStoreDescription.cloudKitContainerOptions?.databaseScope = .private
        container.persistentStoreDescriptions = [/*cloudStoreDescription, */localStoreDescription]
        
        guard let description = container.persistentStoreDescriptions.first else {
//            CrashlyticsService.shared.record(areaOfCrash: #function, customMessage: "Failed to initialize persistent container!")
            return
        }
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        container.loadPersistentStores { (storeDescription, error) in
//            if let error = error as NSError? {
//                CrashlyticsService.shared.record(areaOfCrash: #function,
//                                                 customMessage: "loadPersistentStores has error(s). Error description: \(error.localizedDescription)",
//                                                 error: error)
//                return
//            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.transactionAuthor = "app"
        do {
            try container.viewContext.setQueryGenerationFrom(.current)
        } catch {
//            CrashlyticsService.shared.record(areaOfCrash: #function,
//                                             customMessage: "Failed to pin viewContext to the current generation Error description: \(error.localizedDescription)",
//                                             error: error)
        }
    }
    
    func performInMainContext<T>(_ block: @escaping (NSManagedObjectContext) async throws -> T) async throws -> T {
        let mainContext = container.viewContext
        
        return try await withCheckedThrowingContinuation { continuation in
            mainContext.perform {
                Task {
                    do {
                        let result = try await block(mainContext)
                        continuation.resume(returning: result)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    func performInBgContext<T>(_ block: @escaping (NSManagedObjectContext) async throws -> T, shouldSave: Bool = true) async throws -> T {
        let bgContext = container.newBackgroundContext()
        bgContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return try await withCheckedThrowingContinuation { continuation in
            bgContext.perform {
                Task {
                    do {
                        let result = try await block(bgContext)
                        if bgContext.hasChanges && shouldSave { try bgContext.save() }
                        continuation.resume(returning: result)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
}
