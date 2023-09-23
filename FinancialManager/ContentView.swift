//
//  ContentView.swift
//  FinancialManager
//
//  Created by Adish Perera on 2023-09-21.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @AppStorage("uid") var userID: String = ""
    
    var body: some View {
        
        if userID == ""{
            AuthView()
        }
        else{
            Home()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
