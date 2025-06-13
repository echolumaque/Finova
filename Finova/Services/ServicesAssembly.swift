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
            AccountService(
                coreDataStack: resolver.resolve(CoreDataStack.self)!,
                transactionService: resolver.resolve(TransactionService.self)!
            )
        }
        .inObjectScope(.container)
        .initCompleted { resolver, service in
            Task { await service.initializeService() }
        }
        
        container.register(TransactionService.self) { resolver in
            TransactionService(coreDataStack: resolver.resolve(CoreDataStack.self)!)
        }.inObjectScope(.container)
        
        container.register(CategoryService.self) { resolver in
            CategoryService(coreDataStack: resolver.resolve(CoreDataStack.self)!)
        }
        .inObjectScope(.container)
        .initCompleted { resolver, service in
            Task { await service.initializeService() }
        }
    }
}
