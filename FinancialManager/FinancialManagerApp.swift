//
//  FinancialManagerApp.swift
//  FinancialManager
//
//  Created by Adish Perera on 2023-09-21.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

@main
struct FinancialManagerApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
