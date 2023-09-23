//
//  Home.swift
//  FinancialManager
//
//  Created by Adish Perera on 2023-09-23.
//

import SwiftUI

struct Home: View {
    @StateObject var expenseViewModel: ExpenseViewModel = .init()
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(spacing:12){
                HStack(spacing:15){
                    VStack(alignment:.leading, spacing: 4){
                        Text("Welcome!")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        Text("Adish")
                            .font(.title2.bold())
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    
                    Button{
                        
                    }label: {
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
                TransactionsView()
            }
            .padding()
        }
        .background{
            Color("BG")
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func TransactionsView()->some View{
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
    
    @ViewBuilder
    func ExpenseCardView()->some View{
        GeometryReader{proxy in
            RoundedRectangle(cornerRadius: 20,style: .continuous)
                .fill(.linearGradient(colors: [
                    Color("Gradient1"),
                    Color("Gradient2"),
                    Color("Gradient3"),
                ], startPoint: .topLeading, endPoint: .bottomTrailing))
            
            VStack(spacing: 15)
            {
                VStack(spacing: 15){
                    Text(expenseViewModel.currentMonthDateString())
                        .font(.callout)
                        .fontWeight(.semibold)
                    
                    Text(expenseViewModel.convertExpensesToCurrency(expenses:expenseViewModel.expenses))
                        .font(.system(size: 35,weight: .bold))
                        .lineLimit(1)
                        .padding(.bottom,5)
                }
                .offset(y: -10)
                
                HStack(spacing:15){
                    Image(systemName: "arrow.down")
                        .font(.caption.bold())
                        .foregroundColor(.green)
                        .frame(width: 30, height: 30)
                        .background(.white.opacity(0.7),in: Circle())
                    
                    VStack(alignment: .leading, spacing: 4){
                        Text("Income")
                            .font(.caption)
                            .opacity(0.7)
                        
                        Text(expenseViewModel.convertExpensesToCurrency(expenses: expenseViewModel.expenses, type: .income))
                            .font(.callout)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .fixedSize()
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    
                    Image(systemName: "arrow.up")
                        .font(.caption.bold())
                        .foregroundColor(.green)
                        .frame(width: 30, height: 30)
                        .background(.white.opacity(0.7),in: Circle())
                    
                    VStack(alignment: .leading, spacing: 4){
                        Text("Expenses")
                            .font(.caption)
                            .opacity(0.7)
                        
                        Text(expenseViewModel.convertExpensesToCurrency(expenses: expenseViewModel.expenses, type: .expense))
                            .font(.callout)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .fixedSize()
                    }
                }
                .padding(.horizontal)
                .padding(.trailing)
                .offset(y: 15)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity,maxHeight:.infinity,alignment: .center)
            
        }
        .frame(height:220)
        .padding(.top)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
