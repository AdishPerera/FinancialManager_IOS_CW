//
//  Home.swift
//  FinancialManager
//
//  Created by Adish Perera on 2023-09-23.
//

import SwiftUI
import FirebaseAuth

struct Home: View {
    @StateObject var expenseViewModel: ExpenseViewModel = .init()
    var body: some View {
        NavigationStack{
            @AppStorage("uid") var userID: String = ""
            
                VStack(spacing:12){
                    HStack(spacing:15){
                        VStack(alignment:.leading, spacing: 4){
                            Text("Welcome!")
                                .font(.title2.bold())
                             
                        }
                        .frame(maxWidth: .infinity,alignment: .leading)
                        
                        NavigationLink {
                            FilteredDetailView()
                                .environmentObject(expenseViewModel)
                        } label: {
                            Image(systemName: "hexagon.fill")
                                .foregroundColor(.gray)
                                .overlay(content: {
                                    Circle()
                                        .stroke(.white,lineWidth:2)
                                        .padding(7)
                                })
                                .frame(width: 40, height: 40)
                                .background(Color.white,in:
                                                RoundedRectangle(cornerRadius: 10,style: .continuous))
                                .shadow(color: .black.opacity(0.1),radius: 5,x:5,y:5)
                        }

                    }
                    ExpenseCardView()
                        .environmentObject(expenseViewModel)
                    TransactionsView()
                }
                .padding()
                .background{
                    Color("Background")
                        .ignoresSafeArea()
                }
                .fullScreenCover(isPresented: $expenseViewModel.addNewExpense){
                    expenseViewModel.clearData()
                }content:{
                    NewExpenseView()
                        .environmentObject(expenseViewModel)
                }
                .overlay(alignment: .bottomTrailing){
                    AddButton()
                }
            
            
        }
        .onAppear {
            expenseViewModel.fetchExpenseData()
        }
    }
    
    //Add New Expense Button
    @ViewBuilder
    func AddButton()->some View{
        Button {
            expenseViewModel.addNewExpense.toggle()
        } label: {
            Image(systemName: "plus")
                .font(.system(size:25,weight:.medium))
                .foregroundColor(.white)
                .frame(width:55, height:55)
                .background{
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(
                            LinearGradient(colors: [
                                Color("Gradient1"),
                                Color("Gradient2"),
                                Color("Gradient3"),
                            ], startPoint: .topLeading, endPoint: .bottomTrailing)
                        
                        )
                }
                .shadow(color: .black.opacity(0.1),radius: 5, x: 5, y: 5)
        }
        .padding()
    }
    
    //Transaction View
    @ViewBuilder
    func TransactionsView()->some View{
        ScrollView{
            VStack(spacing: 15){
                Text("Transactions")
                    .font(.title2.bold())
                    .opacity(0.7)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.bottom)
                
                ForEach(expenseViewModel.expenses){expense in
                    TransactionCardView(expense: expense)
                        .environmentObject(expenseViewModel)
                }
            }
            .padding(.top)
        }
    }
    
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
