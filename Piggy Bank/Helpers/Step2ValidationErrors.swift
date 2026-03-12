//
//  Step2ValidationErrors.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//


struct Step2ValidationErrors {
    var checkpointErrors: [(amount: String?, parentContribution: String?)]

    init(checkpointErrors: [(amount: String?, parentContribution: String?)] = []) {
        self.checkpointErrors = checkpointErrors
    }

    var isEmpty: Bool {
        checkpointErrors.allSatisfy { $0.amount == nil && $0.parentContribution == nil }
    }
}