//
//  CheckpointRow.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//
import Foundation

struct CheckpointRow: Identifiable {
    let id = UUID()
    var amount: String
    var parentContribution: String
}
