//
//  Transaction+Extension.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/22/25.
//

import Foundation
import CoreData

extension Transaction {
    convenience init(date: Date = .now, value: Double = 0.0, in context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: context)!
        self.init(entity: entity, insertInto: context)
        self.date = date
        self.value = value
    }
    
    static func getPredefinedTransactions(in context: NSManagedObjectContext, type: [TransactionType]) -> [Transaction] {
        let randomizedTransactions = Array(
            repeating: Transaction(
                date: Date(hour: Int.random(in: 0...23), minute: Int.random(in: 0...59)),
                value: Double.random(in: 1...1000),
                in: context
            ),
            count: 5
        )
        
        for index in randomizedTransactions.indices {
            randomizedTransactions[index].type = type[index]
        }
        
        return randomizedTransactions
    }
}
