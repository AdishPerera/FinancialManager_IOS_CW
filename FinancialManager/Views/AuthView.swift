//
//  AuthView.swift
//  FinancialManager
//
//  Created by Adish Perera on 2023-09-21.
//

import SwiftUI

struct AuthView: View {
    @State private var currentViewShowing: String = "login"
    var body: some View {
        
        if(currentViewShowing == "login"){
            LoginView(CurrentShowingView: $currentViewShowing)
                .preferredColorScheme(.light)
        }
        else{
            SignupView(CurrentShowingView: $currentViewShowing)
                .preferredColorScheme(.light)
                .transition(.move(edge: .bottom))
        }
        
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
