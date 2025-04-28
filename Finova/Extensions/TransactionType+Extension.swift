//
//  TransactionType+Extension.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/22/25.
//

import Foundation
import CoreData

extension TransactionType {
    convenience init(
        typeId: UUID,
        details: String,
        kind: CashflowType,
        name: String,
        in context: NSManagedObjectContext
    ) {
        let entity = NSEntityDescription.entity(forEntityName: "TransactionType", in: context)!
        self.init(entity: entity, insertInto: context)
        self.typeId = typeId
        self.details = details
        self.kind = kind.encode()
        self.name = name
    }
    
    static func getPredefinedTransactions(in context: NSManagedObjectContext) -> [TransactionType] {
        let randomizedTransactionTypes = (0..<5).map { _ in
            TransactionType(
                typeId: UUID(),
                details: "Lorem ipsum dolor.",
                kind: CashflowType.allCases.randomElement() ?? .income,
                name: ["Lorem", "Ipsum", "Dolor", "Sit", "Amet"].randomElement() ?? "",
                in: context
            )
        }
        
        return randomizedTransactionTypes
    }
}
