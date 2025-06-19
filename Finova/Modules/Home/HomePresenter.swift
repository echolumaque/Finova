//
//  HomePresenter.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/10/25.
//

import CoreData
import RxSwift
import UIKit

protocol HomePresenter: AnyObject {
    var router: HomeRouter? { get set }
    var interactor: HomeInteractor? { get set }
    var view: HomeView? { get set }
    
    func didLoad() async
    func gotoAddCashflow(cashflowType: CashflowType)
    func getAccountsMenuData() async -> [UIAction]
    func getPrdefinedTransactions() async
    func getTransactionsOn(frequency: Frequency) async
}

class HomePresenterImpl: HomePresenter {
    var router: (any HomeRouter)?
    var interactor: (any HomeInteractor)?
    weak var view: (any HomeView)?
    
    private var accounts: [Account] = []
    private var currentCredit: Double = 0
    private var currentDebit: Double = 0
    private let disposeBag = DisposeBag()
    private lazy var numberFormatter = FormatterFactory.makeCurrencyFormatter()
    private var selectedAccount: Account?
    private let selectedAccountUpdatedSubject = PublishSubject<Account>()
    
    init() {
        subscribeToAccountChanges()
    }
    
    func didLoad() async {
        let fetchedAccounts = await interactor?.getAccounts() ?? []
        accounts.append(contentsOf: fetchedAccounts)
        selectedAccount = fetchedAccounts.first
        
        guard let selectedAccount else { return }
        view?.updateSelectedAccount(selectedAccount)
        view?.updateAvailableBalance(numberFormatter.string(from: NSNumber(value: selectedAccount.value)) ?? "")
        let initialTxns = await interactor?.getTransactionsOn(account: selectedAccount, frequency: .daily) ?? []
        generateInitialTxns(initialTxns)
        
        subscribeToAccountValueChanges()
        subscribeToTxnChanges()
    }
    
    func gotoAddCashflow(cashflowType: CashflowType) {
        router?.gotoAddCashflow(cashflowType: cashflowType)
    }
    
    func getAccountsMenuData() async -> [UIAction] {
        let actions = await MainActor.run {
            accounts.map { account in
                UIAction(title: account.name ?? "No account", state: selectedAccount == account ? .on : .off) { [weak self] _ in
                    guard let self else { return }
                    selectedAccount = account
                    selectedAccountUpdatedSubject.onNext(account)
                }
            }
        }
        
        return actions
    }
    
    func getPrdefinedTransactions() async {
        let predefinedTransactions = await interactor?.getPrdefinedTransactions() ?? []
        view?.updateTxns(predefinedTransactions.map { $0.convertToVm() })
    }
    
    func getTransactionsOn(frequency: Frequency) async {
        guard let selectedAccount else { return }
        let txns = await interactor?.getTransactionsOn(account: selectedAccount, frequency: frequency)
        let abc = 1
    }
    
    
    private func generateInitialTxns(_ txns: [TransactionCellViewModel]) {
        for txn in txns {
            guard let cashflowType = txn.cashflowType?.decode(CashflowType.self) else { continue }
            switch cashflowType {
            case .credit: currentCredit += txn.value
            case .debit: currentDebit += txn.value
            }
        }
        
        view?.updateCreditCashflowBadge(value: numberFormatter.string(from: currentCredit as NSNumber) ?? "")
        view?.updateDebitCashflowBadge(value: numberFormatter.string(from: currentDebit as NSNumber) ?? "")
        updateTransactions(transactions: txns)
    }
    
    private func updateTransactions(transactions: [TransactionCellViewModel]) {
        view?.updateTxns(transactions)
    }
    
    private func subscribeToAccountChanges() {
        _ = selectedAccountUpdatedSubject
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .subscribe { event in
            switch event {
            case .next(let account):
                Task { [weak self] in
                    guard let self else { return }
                    
                    currentCredit = .zero
                    currentDebit = .zero
                    
                    let txns = await interactor?.getTxnsFrom(account: account) ?? []
                    for txn in txns {
                        guard let cashflowType = txn.cashflowType?.decode(CashflowType.self) else { continue }
                        switch cashflowType {
                        case .credit: currentCredit += txn.value
                        case .debit: currentDebit += txn.value
                        }
                    }
                    
                    view?.updateSelectedAccount(account)
                    view?.updateAvailableBalance(numberFormatter.string(from: NSNumber(value: account.value)) ?? "")
                    view?.updateCreditCashflowBadge(value: numberFormatter.string(from: currentCredit as NSNumber) ?? "")
                    view?.updateDebitCashflowBadge(value: numberFormatter.string(from: currentDebit as NSNumber) ?? "")
                    view?.updateTxnsBasedOnAccount(txns)
                }
                
            case .error(_), .completed: break
            }
        }
        .disposed(by: disposeBag)
    }
    
    private func subscribeToAccountValueChanges() {
        interactor?.accountValueUpdated?
            .skip(1)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] event in
                guard let self else { return }
                
                switch event {
                case .next((let account, let value)):
                    guard selectedAccount == account else { return }
                    view?.updateAvailableBalance(numberFormatter.string(from: NSNumber(value: value)) ?? "")
                    
                case .error(_), .completed: break
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func subscribeToTxnChanges() {
        interactor?.upsertedTxns?
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .map { [weak self] txn in
                let formattedValue = "\(self?.numberFormatter.string(from: NSNumber(floatLiteral: txn?.value ?? 0)) ?? "0")"
                return txn?.convertToVm(formattedValue: formattedValue)
            }
            .subscribe(onNext: { [weak self] txnVm in
                guard let self,
                      let txnVm,
                      selectedAccount == txnVm.account,
                      let cashflowType = txnVm.cashflowType?.decode(CashflowType.self) else { return }
                
                updateTransactions(transactions: [txnVm])
                switch cashflowType {
                case .credit:
                    currentCredit += txnVm.value
                    view?.updateCreditCashflowBadge(value: numberFormatter.string(from: currentCredit as NSNumber) ?? "")
                  
                case .debit:
                    currentDebit += txnVm.value
                    view?.updateDebitCashflowBadge(value: numberFormatter.string(from: currentDebit as NSNumber) ?? "")
                }
            }, onDisposed: {
                print("disposed here")
            })
            .disposed(by: disposeBag)
    }
}
