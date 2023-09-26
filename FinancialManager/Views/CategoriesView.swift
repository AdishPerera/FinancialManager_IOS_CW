//
//  CategoriesView.swift
//  FinancialManager
//
//  Created by Adish Perera on 2023-09-25.
//

import SwiftUI

struct CategoriesView: View {
    //View Properties
    @State private var addCategory: Bool = false
    @State private var categoryName: String = ""
    var body: some View {
        NavigationStack{
            List{
                
            }
            .navigationTitle("Categories")
            //New Category add button
            .overlay(alignment: .bottomTrailing){
                AddButton()
            }
        }
    }
    
    @ViewBuilder
    func AddButton()->some View{
        Button {
            addCategory.toggle()
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
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}
