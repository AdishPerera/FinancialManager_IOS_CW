//
//  ContentView.swift
//  FinancialManager
//
//  Created by Adish Perera on 2023-09-21.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var currentTab: String = "Expenses"
    @StateObject private var expenseViewModel = ExpenseViewModel()
    
    @AppStorage("uid") var userID: String = ""
    
    var body: some View {
        
        if userID == ""{
            AuthView()
        }
        else{
            TabView(selection: $currentTab){
                Home()
                    .navigationBarHidden(true)
                    .tag("Expenses")
                    .tabItem{
                        Image(systemName: "creditcard.fill")
                        Text("Expenses")
                    }
                
                CategoriesView()
                    .tag("Categories")
                    .tabItem{
                        Image(systemName:"list.clipboard.fill")
                        Text("Categories")
                    }
                
                SettingsView()
                    .tag("Settings")
                    .tabItem{
                        Image(systemName:"gear")
                        Text("Settings")
                    }
    
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
