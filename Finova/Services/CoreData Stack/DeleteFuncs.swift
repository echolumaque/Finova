//
//  DeleteFuncs.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/11/25.
//

import CoreData
import Foundation

extension CoreDataStack {
    func deleteAllData(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) async {
        let bgContext = container.newBackgroundContext()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        
        // Perform the batch delete
        let batchDelete = try? bgContext.execute(deleteRequest) as? NSBatchDeleteResult
        guard let deleteResult = batchDelete?.result as? [NSManagedObjectID] else {return }
        
        let deletedObjects = [NSDeletedObjectsKey: deleteResult]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: deletedObjects, into: [viewContext])
    }
    
    nonisolated func internalBatchTestDataDelete<T: NSManagedObject>(ofType type: T.Type) async {
        await internalBatchDelete(ofType: type.self, withPredicate: NSPredicate(format: "isTestData == %@", NSNumber(value: true)))
    }
    
    nonisolated func internalBatchDelete<T: NSManagedObject>(ofType type: T.Type, withPredicate predicate: NSPredicate? = nil) async {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: type))
        request.predicate = predicate
        
        let bgContext = container.newBackgroundContext()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        await bgContext.perform {
            do {
                try bgContext.execute(batchDeleteRequest)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        
        await internalSave(context: bgContext)
    }
    
    func internalBatchDelete<T: NSManagedObject>(ofType type: T.Type, predicateFormat: String, args: any CVarArg...) async {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: type))
        request.predicate = NSPredicate(format: predicateFormat, args)
        
        let bgContext = container.newBackgroundContext()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        await bgContext.perform {
            do {
                try bgContext.execute(batchDeleteRequest)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        
        await internalSave(context: bgContext)
    }
    
    func internalDelete(id: NSManagedObjectID) async {
        let bgContext = container.newBackgroundContext()
        await bgContext.perform {
            if let item = try? bgContext.existingObject(with: id) {
                bgContext.delete(item)
            }
        }
        
        await internalSave(context: bgContext)
    }
    
    @MainActor func internalDelete(_ objToDelete: NSManagedObject) async {
        await viewContext.delete(objToDelete)
        await internalSave(context: viewContext)
    }

    func internalDelete<T: NSManagedObject>(_ request: NSFetchRequest<T>) async {
        let bgContext = container.newBackgroundContext()
        do {
            try await bgContext.perform {
                let results = try bgContext.fetch(request)
                guard let objToDelete = results.first else { return }
                
                bgContext.delete(objToDelete)
            }
            
            await internalSave(context: bgContext)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
