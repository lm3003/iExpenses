//
//  AddExpense.swift
//  iExpense
//
//  Created by Luv Modi on 5/20/24.
//

import Foundation
import SwiftUI
import SwiftData


struct AddExpense: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var expenseName = ""
    @State private var expenseType = "Personal"
    @State private var expenseAmount = 0.0
    
    var expense: UserExpense
    
    let expenseTypes = ["Personal", "Business"]
    
    var body: some View {
        NavigationStack {
            Form {
                List {
                    TextField("Name", text: $expenseName)
                    Picker("Expense Type", selection: $expenseType) {
                        ForEach(expenseTypes, id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("Expense amount", value: $expenseAmount, format: .currency(code: "USD"))
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add New Expense")
            .toolbar {
                Button("Save") {
                    let item = ExpenseItem(name: expenseName, value: expenseAmount, type: expenseType)
                    expense.expenses.append(item)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddExpense(expense: UserExpense())
}
