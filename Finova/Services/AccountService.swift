//
//  AccountService.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/11/25.
//

import Foundation

actor AccountService {
    private let coreDataStack: CoreDataStack
    private var didInitialize = false
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func initializeService() async {
        guard !didInitialize else { return }
        didInitialize = true
        
        do {
            try await coreDataStack.performInBgContext { context in
                let request = Account.fetchRequest()
                request.resultType = .countResultType
                if try context.count(for: request) > 0 { return }
                
                let accountNames = ["Checking", "Savings", "Investments"]
                for name in accountNames {
                    let account = Account(context: context)
                    account.name = name
                    account.value = 0
                }
                
                try context.save()
            }
        } catch {
            print(error)
        }
    }
    
    func getAccounts() async -> [Account] {
        let accounts = try? await coreDataStack.performInMainContext { context in
            let request = Account.fetchRequest()
            return try? context.fetch(request)
        }
        
        return accounts ?? []
    }
}
