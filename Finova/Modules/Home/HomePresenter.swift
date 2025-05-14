//
//  HomePresenter.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/10/25.
//

import CoreData
import UIKit

protocol HomePresenter: AnyObject {
    var router: HomeRouter? { get set }
    var interactor: HomeInteractor? { get set }
    var view: HomeView? { get set }
    
    func gotoAddCashflow(cashflowType: CashflowType)
    func getTransactions() async
    func getAccounts() async
    func getPrdefinedTransactions() async
    
    func interactorDidFetchInitial(_ transactions: [Transaction])
    func interactorDidChange(
        transaction: Transaction,
        at indexPath: IndexPath?,
        for change: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    )
}

class HomePresenterImpl: HomePresenter {
    var router: (any HomeRouter)?
    var interactor: (any HomeInteractor)?
    weak var view: (any HomeView)?
    
    private var items: [Transaction] = []
    private var hasDoneInitialLoad = false
    
    func getAccounts() async {
        let accounts = await interactor?.getAccounts() ?? []
        view?.updateAccounts(accounts)
    }
    
    func getTransactions() async {
//        let transactions = await interactor?.getTransactions() ?? []
//        view?.updateTransactions(transactions)
        
        await interactor?.startListening()
    }
    
    func getPrdefinedTransactions() async {
        let predefinedTransactions = await interactor?.getPrdefinedTransactions() ?? []
        view?.updateTransactions(predefinedTransactions)
    }
    
    func gotoAddCashflow(cashflowType: CashflowType) {
        router?.gotoAddCashflow(cashflowType: cashflowType)
    }
    
    private func makeSnapshot(from txns: [Transaction]) -> NSDiffableDataSourceSnapshot<Section, Transaction> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Transaction>()
        snapshot.appendSections([.main])
        snapshot.appendItems(txns, toSection: .main)
        return snapshot
    }
    
    func interactorDidFetchInitial(_ transactions: [Transaction]) {
        let snap = makeSnapshot(from: transactions)
        view?.applySnapshot(snap)
        hasDoneInitialLoad = true
    }
    
    func interactorDidChange(
        transaction: Transaction,
        at indexPath: IndexPath?,
        for change: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch change {
        case .insert:
            if let idx = newIndexPath?.item {
                items.insert(transaction, at: idx)
            }
        case .delete:
            if let idx = indexPath?.item {
                items.remove(at: idx)
            }
        case .move:
            if let from = indexPath?.item, let to = newIndexPath?.item {
                let moved = items.remove(at: from)
                items.insert(moved, at: to)
            }
        case .update:
            if let idx = indexPath?.item {
                items[idx] = transaction
            }
        @unknown default:
            break
        }
        
        let snap = makeSnapshot(from: items)
        view?.applySnapshot(snap)
    }
}
