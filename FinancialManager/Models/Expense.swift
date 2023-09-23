//
//  Expense.swift
//  FinancialManager
//
//  Created by Adish Perera on 2023-09-23.
//

import SwiftUI

struct Expense: Identifiable,Hashable{
    var id = UUID().uuidString
    var remark: String
    var amount: Double
    var date: Date
    var type: ExpenseType
    var color: String
}

enum ExpenseType: String{
    case income = "Income"
    case expense = "Expenses"
    case all = "ALL"
}

var sample_expenses: [Expense] = [
    Expense(remark: "Food", amount: 15, date: Date(timeIntervalSince1970: 1652987245), type: .expense, color: "Gradient2")
]
