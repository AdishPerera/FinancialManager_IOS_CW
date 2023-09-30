//
//  ExpenseViewModel.swift
//  FinancialManager
//
//  Created by Adish Perera on 2023-09-23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

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
    @Published var categories: [Category] = []
    @Published var selectedCategoryIndex: Int = 0
    @Published var selectedCategoryName: String?

    
    var alertMessage:String = ""
    var showAlert = false
    
    init(){
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year,.month], from: Date())
        
        startDate = calendar.date(from:components)!
        currentMonthStartDate = calendar.date(from: components)!
    }
    
    @Published var expenses: [Expense] = []
    
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
    
    func addExpense(_ expense: Expense) {
        withAnimation {
            self.expenses.insert(expense, at: 0)
        }
        fetchExpenseData()
    }
    
    //Save Expense Data
    func saveExpenseData(env: EnvironmentValues, categoryName: String?) {
        guard let currentUser = Auth.auth().currentUser else {
                self.alertMessage = "User not authenticated"
                self.showAlert = true
                return
            }
        
        let uid = currentUser.uid
        let db = Firestore.firestore()
        let amountInDouble = (amount as NSString).doubleValue
        let colors = ["Yellow", "Red", "Purple", "Green"]
        let expenseData: [String: Any] = [
            "userId": uid,
            "remark": remark,
            "amount": amountInDouble,
            "date": Timestamp(date: date),
            "type": type.rawValue,
            "category": categoryName ?? "",
            "color": colors.randomElement() ?? "Yellow"
        ]
        
        db.collection("Expenses").addDocument(data: expenseData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully!")
                let newExpense = Expense(
                    remark: self.remark,
                                amount: amountInDouble,
                                date: self.date,
                                type: self.type,
                                color: colors.randomElement() ?? "Yellow",
                                category: categoryName ?? ""
                            )
                            self.addExpense(newExpense)
                            env.dismiss()
            }
        }
    }
    
    //Fetch Expense data
    func fetchExpenseData() {
        let db = Firestore.firestore()
        
        guard let currentUser = Auth.auth().currentUser else {
            print("User not authenticated")
            return
        }
        
        let uid = currentUser.uid
        
        db.collection("Expenses")
            .whereField("userId", isEqualTo: uid)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching data: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents found.")
                    return
                }
                
                let fetchedExpenses = documents.compactMap { document -> Expense? in
                    let data = document.data()
                    
                    guard
                        let remark = data["remark"] as? String,
                        let amount = data["amount"] as? Double,
                        let dateTimestamp = data["date"] as? Timestamp,
                        let typeRawValue = data["type"] as? String,
                        let color = data["color"] as? String,
                        let category = data["category"] as? String
                    else {
                        return nil
                    }
                    
                    let date = dateTimestamp.dateValue()
                    let type = ExpenseType(rawValue: typeRawValue) ?? .all
                    
                    return Expense(remark: remark, amount: amount, date: date, type: type, color: color, category: category)
                }
                
                withAnimation {
                    self.expenses = fetchedExpenses.sorted(by: { first, second in
                        return second.date < first.date
                    })
                }
            }
    }

    //Save Category Data
    func saveCategoryData(categoryName: String) {
        guard let currentUser = Auth.auth().currentUser else {
                self.alertMessage = "User not authenticated"
                self.showAlert = true
                return
            }
            
            let db = Firestore.firestore()
            let categoriesCollection = db.collection("Categories")
            
            let newCategoryRef = categoriesCollection.document()
            let uid = currentUser.uid
            let categoryData: [String: Any] = [
                "userId": uid,
                "name": categoryName
            ]
            
            newCategoryRef.setData(categoryData) { error in
                if let error = error {
                    print("Error adding category: \(error)")
                } else {
                    print("Category added successfully!")
                }
            }
        }
    

    //Fetch Category data
    func fetchCategoriesData() {
        let db = Firestore.firestore()
        
        guard let currentUser = Auth.auth().currentUser else {
            // Handle the case when the user is not authenticated.
            print("User not authenticated")
            return
        }
        
        let uid = currentUser.uid
        
        let categoriesCollection = db.collection("Categories").whereField("userId", isEqualTo: uid)

        categoriesCollection.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching categories: \(error)")
                return
            }

            // Clear existing categories
            self.categories.removeAll()

            // Parse and add fetched categories to the array
            for document in querySnapshot!.documents {
                if let categoryName = document.data()["name"] as? String {
                    self.categories.append(Category(name: categoryName))
                }
            }
        }
    }
    
    //Delete Category Data
    func deleteCategoryFromDatabase(categoryID: String) {
        guard let currentUser = Auth.auth().currentUser else {
            self.alertMessage = "User not authenticated"
            self.showAlert = true
            return
        }

        let db = Firestore.firestore()
        let categoriesCollection = db.collection("Categories")

        categoriesCollection.document(categoryID).delete { error in
            if let error = error {
                print("Error deleting category: \(error)")
            } else {
                print("Category deleted successfully!")
            }
        }
    }

}
