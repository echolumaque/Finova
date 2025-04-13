//
//  UpdateFuncs.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/11/25.
//

import CoreData
import Foundation

extension CoreDataStack {
    func internalBatchUpdate(context: NSManagedObjectContext? = nil,
                             entity: NSEntityDescription,
                             predicate: NSPredicate? = nil,
                             propertiesToUpdate: [AnyHashable: Any]?) async {
        let bgContext = context ?? container.newBackgroundContext()
        do {
            try await bgContext.perform {
                let batchUpdateRequest = NSBatchUpdateRequest(entity: entity)
                batchUpdateRequest.predicate = predicate
                batchUpdateRequest.propertiesToUpdate = propertiesToUpdate
                
                try bgContext.execute(batchUpdateRequest)
            }
        } catch {
//            CrashlyticsService.shared.record(areaOfCrash: #function, error: error)
        }
    }
    
    @discardableResult
    func internalUpdate<Object, Value>(objToUpdate: Object,
                                       keyPath: ReferenceWritableKeyPath<Object, Value>,
                                       newValue: Value) async -> Object {
        await MainActor.run { objToUpdate[keyPath: keyPath] = newValue }
        await internalSave(context: viewContext)
        
        return objToUpdate
    }
    
    @discardableResult
    func internalUpdate<Object, Value>(objToUpdate: Object, updates: [(ReferenceWritableKeyPath<Object, Value>, Value)]) async -> Object {
        await MainActor.run {
            for (keyPath, newValue) in updates {
                objToUpdate[keyPath: keyPath] = newValue
            }
        }
        await internalSave(context: viewContext)
        
        return objToUpdate
    }
}
