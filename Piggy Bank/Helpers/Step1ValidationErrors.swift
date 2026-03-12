//
//  Step1ValidationErrors.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//


struct Step1ValidationErrors {
    var goalName: String?
    var goalAmount: String?
    var icon: String?

    init(goalName: String? = nil, goalAmount: String? = nil, icon: String? = nil) {
        self.goalName = goalName
        self.goalAmount = goalAmount
        self.icon = icon
    }

    var isEmpty: Bool {
        goalName == nil && goalAmount == nil && icon == nil
    }
}
