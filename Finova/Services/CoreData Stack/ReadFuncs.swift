//
//  ReadFuncs.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/11/25.
//

import CoreData
import Foundation

extension CoreDataStack {
    func internalCount<T: NSManagedObject>(_ request: NSFetchRequest<T>) async -> Int {
        let bgContext = container.newBackgroundContext()
        do {
            let count = try await bgContext.perform {
                request.resultType = .countResultType
                let entityCount = try bgContext.count(for: request)
                return entityCount
            }
            
            return count
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    @MainActor func internalFetchBy<T: NSManagedObject>(objectID: NSManagedObjectID) async -> T? {
        let fetchedObject = try? await viewContext.existingObject(with: objectID) as? T
        return fetchedObject
    }
    
    func singleInternalFetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) async -> T? {
        request.fetchLimit = 1
        request.fetchBatchSize = 1
        let bgContext = container.newBackgroundContext()
        let firstObject = await bgContext.perform {
            do {
                let fetchedObjects = try bgContext.fetch(request)
                return fetchedObjects.first
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        
        guard let firstObject else { return nil }
        let objectToReturn = await internalFetchBy(objectID: firstObject.objectID) as? T
        
        return objectToReturn
    }
    
    func internalFetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) async -> [T] {
        let bgContext = container.newBackgroundContext()
        let objectIds = await bgContext.perform {
            do {
                let fetchedObjects = try bgContext.fetch(request)
                return fetchedObjects.compactMap({ $0.objectID })
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        
        var fetchedObjects: [T] = []
        for objectId in objectIds {
            guard let fetchedObject = await internalFetchBy(objectID: objectId) as? T else { continue }
            fetchedObjects.append(fetchedObject)
        }
        
        return fetchedObjects
    }
    
    nonisolated func internalFetchSingleAttribute<T>(entityName: String,
                                                     attributeToFetch: String,
                                                     attributeType: NSAttributeType,
                                                     predicate: NSPredicate? = nil,
                                                     parseAs: T.Type) async -> [T]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = "key"
        expressionDescription.expression = NSExpression(forKeyPath: attributeToFetch)
        expressionDescription.expressionResultType = attributeType
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        fetchRequest.resultType = .dictionaryResultType
        
        do {
            let bgContext = container.newBackgroundContext()
            let parsedData: [T] = try await bgContext.perform {
                guard let fetchedData = try bgContext.fetch(fetchRequest) as? [[String: Any]] else { return [] }
                let parsedData = fetchedData.compactMap({ $0["key"] as? T })
                
                return parsedData
            }
            
            return parsedData
        } catch {
            return nil
        }
    }
}
