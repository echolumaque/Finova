//
//  HomeInteractor.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/10/25.
//

import CoreData
import Foundation

protocol HomeInteractor: AnyObject {
    var presenter: HomePresenter? { get set }
    func getAccounts() async -> [Account]
    func getTransactions()
    func getTransactions() async -> [Transaction]
    func getPrdefinedTransactions() async -> [Transaction]
    func startListening() async
}

class HomeInteractorImpl: NSObject, HomeInteractor {
    weak var presenter: (any HomePresenter)?
    
    private let accountService: AccountService
    private let coreDataStack: CoreDataStack
    private let transactionService: TransactionService
    
    private var frc: NSFetchedResultsController<Transaction>?
    
    init(
        accountService: AccountService,
        coreDataStack: CoreDataStack,
        transactionService: TransactionService
    ) {
        self.accountService = accountService
        self.coreDataStack = coreDataStack
        self.transactionService = transactionService
    }
    
    func getAccounts() async -> [Account] {
        let accounts = await accountService.getAccounts()
        return accounts
    }
    
    func getTransactions() {
        
    }
    
    func getTransactions() async -> [Transaction] {
        let transactions = await transactionService.getTransactionsOn()
        return transactions
    }
    
    func getPrdefinedTransactions() async -> [Transaction] {
        let predefinedTransactions = await transactionService.getPredefinedTransactions()
        return predefinedTransactions
    }
    
    @MainActor
    func startListening() async {
        let context = await coreDataStack.viewContext
        let request = Transaction.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)]
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        frc = controller
        
        do {
            try frc?.performFetch()
            let initialTransactions = frc?.fetchedObjects ?? []
            presenter?.interactorDidFetchInitial(initialTransactions)
        } catch {
            
        }
    }
}

extension HomeInteractorImpl: NSFetchedResultsControllerDelegate {
    func controller(
        _ controller: NSFetchedResultsController<any NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        guard let txn = anObject as? Transaction, let presenter else { return }
        presenter.interactorDidChange(transaction: txn, at: indexPath, for: type, newIndexPath: newIndexPath)
    }
}
