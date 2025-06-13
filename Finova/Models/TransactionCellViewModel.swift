//
//  TransactionCellViewModel.swift
//  Finova
//
//  Created by Jhericoh Lumaque on 6/11/25.
//

import Foundation

struct TransactionCellViewModel: Hashable {
    let attachment: Data?
    let cashflowType: Data?
    let date: Date?
    let desc: String?
    let txnId: UUID?
    let value: Double
    let account: Account?
    let category: Category?
    let formattedValue: String?
}

extension Transaction {
    func convertToVm(formattedValue: String? = nil) -> TransactionCellViewModel {
        TransactionCellViewModel(
            attachment: self.attachment,
            cashflowType: self.cashflowType,
            date: self.date,
            desc: self.desc,
            txnId: self.txnId,
            value: self.value,
            account: self.account,
            category: self.category,
            formattedValue: formattedValue
        )
    }
}
