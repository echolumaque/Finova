//
//  AccountService.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/11/25.
//

import CoreData
import Foundation
import RxSwift

actor AccountService {
    private let coreDataStack: CoreDataStack
    private var didInitialize = false
    private let disposeBag = DisposeBag()
    private let transactionService: TransactionService
    
    private let accountValueUpdatedSubject = BehaviorSubject<(Account?, Double)>(value: (nil, .zero))
    var accountValueUpdated: Observable<(Account?, Double)> { accountValueUpdatedSubject.asObservable() }
    
    init(coreDataStack: CoreDataStack, transactionService: TransactionService) {
        self.coreDataStack = coreDataStack
        self.transactionService = transactionService
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
                    account.value = 100000
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
    
    func getTxnsFrom(account: Account) async -> [Transaction] {
        let txns = try? await coreDataStack.performInMainContext { context in
            let request = Transaction.fetchRequest()
            request.predicate = NSPredicate(format: "account == %@", account)
            
            return try? context.fetch(request)
        }
        
        return txns ?? []
    }
    
    func updateAccountValue(account: Account, txnType: TransactionType) async {
        do {
            let updatedAccountValue = try await coreDataStack.performInBgContext { ctx -> Double in
                guard let fetchedAccount = try ctx.existingObject(with: account.objectID) as? Account else { return 0 }
                
                switch txnType {
                case .credit(let value): fetchedAccount.value += value
                case .debit(let value): fetchedAccount.value -= value
                }
                
                try ctx.save()
                
                return fetchedAccount.value
            }
            
            accountValueUpdatedSubject.onNext((account, updatedAccountValue))
        } catch {
            print(error)
            accountValueUpdatedSubject.onError(error)
        }
    }
    
//    private func onAccountValueUpdated(account: Account, txnType: TransactionType) {
//        Task { [weak self] in
//            guard let self else { return }
//            
//            do {
//                try await coreDataStack.performInBgContext { ctx in
//                    guard let fetchedAccount = try ctx.existingObject(with: account.objectID) as? Account else { return }
//                    
//                    switch txnType {
//                    case .credit(let value): fetchedAccount.value += value
//                    case .debit(let value): fetchedAccount.value -= value
//                    }
//                    
//                    try ctx.save()
//                }
//            } catch {
//                print(error)
//            }
//        }
//    }
}
