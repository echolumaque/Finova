//
//  AccountService.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/11/25.
//

import Foundation

actor AccountService {
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func getPredefinedAccounts() async -> [Account] {
        let viewContext = await coreDataStack.viewContext
        return Account.getPredefinedAccounts(in: viewContext)
    }
}
