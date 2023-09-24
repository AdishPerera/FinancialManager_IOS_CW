//
//  ExpenseViewModel.swift
//  FinancialManager
//
//  Created by Adish Perera on 2023-09-23.
//

import SwiftUI

class ExpenseViewModel: ObservableObject {
    //Properties
    
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var currentMonthStartDate: Date = Date()
    
    //Expense/ Income Tab
    @Published var tabName: ExpenseType = .expense
    
    //Filter View
    @Published var showFilterView: Bool = false
    
    //New Expense Properties
    @Published var addNewExpense: Bool = false
    @Published var amount: String = ""
    @Published var type: ExpenseType = .all
    @Published var date: Date = Date()
    @Published var remark: String = ""
    
    init(){
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year,.month], from: Date())
        
        startDate = calendar.date(from:components)!
        currentMonthStartDate = calendar.date(from: components)!
    }
    
    @Published var expenses:[Expense] = sample_expenses
    
    func currentMonthDateString()->String{
        return currentMonthStartDate.formatted(date:.abbreviated,time:.omitted) + " - " +
        Date().formatted(date:.abbreviated,time:.omitted)
    }
    
    func convertExpensesToCurrency(expenses:[Expense],type: ExpenseType = .all)->String{
        var value: Double = 0
        value = expenses.reduce(0,{partialResult, expense in
            return partialResult + (type == .all ? (expense.type == .income ? expense.amount : -expense.amount) : (expense.type == type ? expense.amount : 0))
        })
        
        return convertNumberToPrice(value: value)
    }
    
    //Converting Selected Dates to String
    func convertDateToString()->String{
        return startDate.formatted(date:.abbreviated,time:.omitted) + " - " +
        endDate.formatted(date:.abbreviated,time:.omitted)
    }
    
    //Converting Number to Price
    func convertNumberToPrice(value:Double)->String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter.string(from: .init(value: value)) ?? "$0.00"
    }
    
    //Clearing all data
    func clearData(){
        date = Date()
        type = .all
        remark = ""
        amount = ""
    }
    
    //Save Data
    func saveData(env: EnvironmentValues){
        print("Save")
        let amountInDouble = (amount as NSString).doubleValue
        let colors = ["Gradient1","Gradient2","Gradient3"]
        let expense = Expense(remark: remark, amount: amountInDouble, date: date, type: type, color: colors.randomElement() ?? "Gradient2")
        withAnimation{expenses.append(expense)}
        expenses = expenses.sorted(by: {first,scnd in
            return scnd.date < first.date
        })
        env.dismiss()
    }
}


