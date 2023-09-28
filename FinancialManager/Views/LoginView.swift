//
//  LoginView.swift
//  FinancialManager
//
//  Created by Adish Perera on 2023-09-21.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @Binding var CurrentShowingView: String
    @AppStorage("uid") var userID: String = ""
    
    @State private var email:String = ""
    @State private var password:String = ""
    
    @State private var loginError: String? = nil
    
    private func isValidPassword(_ password: String) -> Bool{
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        
        return passwordRegex.evaluate(with: password)
    }
    
    var body: some View {
        ZStack{
            Color.white.edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    Text("Welcome Back!").font(.largeTitle).bold()
                    
                    Spacer()
                }
                .padding()
                .padding(.top)
                
                Spacer()
                
                HStack{
                    Image(systemName: "mail")
                    TextField("Email", text: $email)
                    
                    Spacer()
                    
                    if(email.count != 0){
                        Image(systemName: email.invalidEmail() ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(email.invalidEmail() ? .green : .red)
                    }
                    
                    
                }
                .padding()
                .overlay{
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                }
                .padding()
                
                HStack{
                    Image(systemName: "lock")
                    SecureField("Password", text: $password)
                    
                    Spacer()
                    
                    if(password.count != 0){
                        Image(systemName: isValidPassword(password) ?  "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(isValidPassword(password) ? .green : .red)
                    }
                    
                }
                .padding()
                .overlay{
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                }
                .padding()
                
                Button(action: {
                    withAnimation{
                        self.CurrentShowingView = "signup"
                    }
                }){
                    Text("Don't have an account?")
                        .foregroundColor(.black.opacity(0.7))
                }
                
                Spacer()
                Spacer()
                
                if let loginError = loginError {
                                Text(loginError)
                                    .foregroundColor(.red)
                                    .padding()
                            }
                
                Button {
                    
                    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                        if let error = error{
                            print(error)
                            self.loginError = "Invalid email or password"
                            return
                        }
                        
                        if let authResult = authResult{
                            print(authResult.user.uid)
                            withAnimation{
                                userID = authResult.user.uid
                            }
                        }
                    }
                    
                }label:{
                    Text("Sign In")
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black)
                        )
                        .padding(.horizontal)
                    
                }
                
            }
        }
    }
}

