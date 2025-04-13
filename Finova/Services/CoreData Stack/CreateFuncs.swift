//
//  CreateFuncs.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/11/25.
//

import CoreData
import Foundation

extension CoreDataStack {
    func internalBatchInsert(entity: NSEntityDescription, elements: [[String: Any]]) async {
        let bgContext = container.newBackgroundContext()
        let insertRequest = NSBatchInsertRequest(entity: entity, objects: elements)
        insertRequest.resultType = .objectIDs
        do {
            let awaitedViewContext = viewContext
            try await bgContext.perform {
                let result = try bgContext.execute(insertRequest) as? NSBatchInsertResult
                guard let objectIDs = result?.result as? [NSManagedObjectID], !objectIDs.isEmpty else { return }
                
                let save = [NSInsertedObjectsKey: objectIDs]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: save, into: [awaitedViewContext])
            }
        } catch {
            print("Error in batch insert: \(error.localizedDescription)")
        }
    }
    
    func internalSave(context: NSManagedObjectContext) async{
        do {
            if context.concurrencyType == .mainQueueConcurrencyType {
                try await viewContext.perform {
                    try self.viewContext.save()
                }
            } else {
                try await context.perform {
                    try context.save()
                }
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
