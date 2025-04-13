//
//  Account+Extension.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/11/25.
//

import CoreData

extension Account {
    convenience init(
        mockName: String = "Default Account",
        mockValue: Double = 0.0,
        in context: NSManagedObjectContext
    ) {
        let entity = NSEntityDescription.entity(forEntityName: "Account", in: context)!
        self.init(entity: entity, insertInto: context)
        self.name = mockName
        self.value = mockValue
    }
    
    static func getPredefinedAccounts(in context: NSManagedObjectContext) -> [Account] {
        return [
            Account(mockName: "Checking", mockValue: 500, in: context),
            Account(mockName: "Savings", mockValue: 1500, in: context),
            Account(mockName: "Investments", mockValue: 3000, in: context)
        ]
    }
}
