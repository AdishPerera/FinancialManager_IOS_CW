//
//  NewExpenseView.swift
//  FinancialManager
//
//  Created by Adish Perera on 2023-09-24.
//

import SwiftUI

struct NewExpenseView: View {
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    //Environment Values
    @Environment(\.self) var env
    var body: some View {
        VStack{
            VStack(spacing:15){
                Text("Add Expenses")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .opacity(0.5)
                
                //Custom TextField for Currency
                if let symbol = expenseViewModel.convertNumberToPrice(value: 0).first{
                    TextField("0", text: $expenseViewModel.amount)
                        .font(.system(size: 35))
                        .foregroundColor(Color("Gradient2"))
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .background{
                            Text(expenseViewModel.amount == "" ? "0" : expenseViewModel.amount)
                                .font(.system(size:35))
                                .opacity(0)
                                .overlay(alignment: .leading){
                                    Text(String(symbol))
                                        .opacity(0.5)
                                        .offset(x: -15, y: 5)
                                }
                        }
                        .padding(.vertical,10)
                        .frame(maxWidth: .infinity)
                        .background{
                            Capsule()
                                .fill(.white)
                        }
                        .padding(.horizontal,20)
                        .padding(.top)
                }
                
                //Custom Labels
                Label {
                    TextField("Remark", text: $expenseViewModel.remark)
                        .padding(.leading,10)
                } icon: {
                    Image(systemName:"list.bullet.rectangle.fill")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                .padding(.vertical,20)
                .padding(.horizontal,15)
                .background{
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.white)
                }
                .padding(.top,25)
                
                Label {
                    //Checkboxes
                    CustomCheckBoxes()
                } icon: {
                    Image(systemName:"arrow.up.arrow.down")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                .padding(.vertical,20)
                .padding(.horizontal,15)
                .background{
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.white)
                }
                .padding(.top,5)
                
                HStack {
                    Image(systemName: "tag")
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    Text("Select Category")
                            .foregroundColor(.black)
                            .frame(width: 150, alignment: .leading)
                    
                    Picker(selection: $expenseViewModel.selectedCategoryIndex, label: Text("Select Category")) {
//                        Text("Select Category")
//                            .foregroundColor(.black)
//                            .tag(nil as Int?) // Default value
                        ForEach(0..<expenseViewModel.categories.count, id: \.self) { index in
                            Text(expenseViewModel.categories[index].name)
                                .foregroundColor(.black) // Set the font color to black
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Spacer() // Pushes the icon and picker to the leading edge
                }
                .padding(.vertical,20)
                
                Label {
                    DatePicker.init("", selection: $expenseViewModel.date,in:Date.distantPast...Date(),displayedComponents: [.date])
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading,10)
                } icon: {
                    Image(systemName:"calendar")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                .padding(.vertical,20)
                .padding(.horizontal,15)
                .background{
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.white)
                }
                .padding(.top,5)
            }
            .frame(maxHeight: .infinity,alignment: .center)
            
            //Save Button
            Button(action:{expenseViewModel.saveExpenseData(env:env, selectedCategoryIndex: expenseViewModel.selectedCategoryIndex)}){
                Text("Save")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.vertical,15)
                    .frame(maxWidth: .infinity)
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
                    .foregroundColor(.white)
                    .padding(.bottom,10)
            }
            .disabled(expenseViewModel.remark == "" || expenseViewModel.type == .all || expenseViewModel.amount == "")
            .opacity(expenseViewModel.remark == "" || expenseViewModel.type == .all || expenseViewModel.amount == "" ? 0.6 : 1)

        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background{
            Color(.white)
                .ignoresSafeArea()
        }
        .overlay(alignment: .topTrailing){
            //Close Button
            Button{
                env.dismiss()
            }label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.black)
                    .opacity(0.7)
            }
            .padding()
        }
        .onAppear {
            expenseViewModel.fetchCategoriesFromFirebase()
        }
    }
    
    //Checkboxes
    @ViewBuilder
    func CustomCheckBoxes()-> some View{
        HStack(spacing: 10){
            ForEach([ExpenseType.income,ExpenseType.expense],id:\.self){type in
                ZStack{
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(.black,lineWidth: 2)
                        .opacity(0.5)
                        .frame(width: 20,height: 20)
                    
                    if expenseViewModel.type == type{
                        Image(systemName: "checkmark")
                            .font(.caption.bold())
                            .foregroundColor(.green)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    expenseViewModel.type = type
                }
                
                Text(type.rawValue.capitalized)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .opacity(0.7)
                    .padding(.trailing,10)
            }
            
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding(.leading,10)
    }
}

struct NewExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        NewExpenseView()
            .environmentObject(ExpenseViewModel())
    }
}
