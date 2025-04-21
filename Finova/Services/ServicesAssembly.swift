//
//  ServicesAssembly.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/10/25.
//

import Swinject

class ServicesAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CoreDataStack.self) { _ in CoreDataStack() }
            .inObjectScope(.container)
        
        container.register(AccountService.self) { resolver in
            AccountService(coreDataStack: resolver.resolve(CoreDataStack.self)!)
        }.inObjectScope(.container)
        
        container.register(TransactionService.self) { resolver in
            TransactionService(coreDataStack: resolver.resolve(CoreDataStack.self)!)
        }.inObjectScope(.container)
    }
}
