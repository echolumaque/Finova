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
        desc: String,
        in context: NSManagedObjectContext
    ) {
        let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: context)!
        self.init(entity: entity, insertInto: context)
        self.txnId = txnId
        self.date = date
        self.value = value
        self.desc = desc
    }
    
    static func getPredefinedTransactions(in context: NSManagedObjectContext, categories: [Category]) -> [Transaction] {
        var transactions: [Transaction] = []
        for category in categories.prefix(Int.random(in: 1...15)) {
            let count = Int.random(in: 1...3)
            for _ in 0..<count {
                let txn = Transaction(
                    txnId: UUID(),
                    date: Date(
                        year: Date.now.year, month: Date.now.month,
                        day: Date.now.day,
                        hour: Int.random(in: 0...23),
                        minute: Int.random(in: 0...59)
                    ),
                    value: Double.random(in: 1...1000),
                    desc: category.randomDescription(),
                    in: context
                )
                txn.category = category
                transactions.append(txn)
            }
        }
        
        return transactions.sorted { $0.date.safelyUnwrappedToNow > $1.date.safelyUnwrappedToNow }
    }
}
