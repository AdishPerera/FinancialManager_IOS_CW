//
//  CategoriesView.swift
//  FinancialManager
//
//  Created by Adish Perera on 2023-09-25.
//

import SwiftUI

struct Category: Identifiable {
    let id = UUID()
    let name: String
}

struct CategoriesView: View {
    // View Properties
    @State private var addCategory: Bool = false
    @State private var categoryName: String = ""
    @State private var categories: [Category] = [] // Array to store categories
    @StateObject private var expenseViewModel = ExpenseViewModel()

    // Calculate whether there are categories or not
    private var hasCategories: Bool {
        !categories.isEmpty
    }
    
    private var hasAllCategories: Bool {
        !expenseViewModel.categories.isEmpty
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(expenseViewModel.categories) { category in
                        Text(category.name)
                    }
                    .onDelete(perform: deleteCategory)
                ForEach(categories) { category in
                    Text(category.name)
                }
                .onDelete(perform: deleteCategory)
            }
            .navigationTitle("Categories")
            .overlay(alignment: .bottomLeading){
                Spacer()
                if hasCategories || hasAllCategories{
                    EditButton()
                        .padding()
                }
                
            }
            .overlay(alignment: .bottomTrailing){
                AddButton()
            }
        }
        .sheet(isPresented: $addCategory, onDismiss: {
            // Handle the category addition here
            if !categoryName.isEmpty {
                categories.append(Category(name: categoryName))
                expenseViewModel.saveCategoryData(categoryName: categoryName)
                categoryName = ""
            }
        }) {
            // Add Category Form
            VStack {
                TextField("Category Name", text: $categoryName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action:{addCategory.toggle()}){
                    Text("Add Category")
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
                .padding()
            }
            .background{
                Color("Background")
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            expenseViewModel.fetchCategoriesFromFirebase()
        }
    }

    // Function to delete a category
    func deleteCategory(at offsets: IndexSet) {
        categories.remove(atOffsets: offsets)
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
