//
//  Transaction+Extension.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/22/25.
//

import Foundation
import CoreData

extension Transaction {
    convenience init(
        txnId: UUID,
        date: Date = .now,
        value: Double = 0.0,
        in context: NSManagedObjectContext
    ) {
        let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: context)!
        self.init(entity: entity, insertInto: context)
        self.txnId = txnId
        self.date = date
        self.value = value
    }
    
    static func getPredefinedTransactions(in context: NSManagedObjectContext, type: [Category]) -> [Transaction] {
        let randomizedTransactions = (0..<15).map { _ in
            Transaction(
                txnId: UUID(),
                date: Date(
                    year: Date.now.year, month: Date.now.month,
                    day: Date.now.day,
                    hour: Int.random(in: 0...23),
                    minute: Int.random(in: 0...59)
                ),
                value: Double.random(in: 1...1000),
                in: context
            )
        }
        
        for index in randomizedTransactions.indices {
            randomizedTransactions[index].category = type[index]
        }
        
        return randomizedTransactions.sorted { $0.date.safelyUnwrappedToNow > $1.date.safelyUnwrappedToNow }
    }
}
