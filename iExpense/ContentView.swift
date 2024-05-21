//
//  ContentView.swift
//  iExpense
//
//  Created by Luv Modi on 5/17/24.
//

//iExpense will get user expense and classify it as personal or business expense

//create expense

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let value: Double
    let type: String
}

@Observable
class UserExpense {
    var expenses = [ExpenseItem]() {
        didSet {
            if let encodedExpenses = try? JSONEncoder().encode(expenses) {
                UserDefaults.standard.set(encodedExpenses, forKey: "expenses")
            }
        }
    }
    
    init() {
        if let savedExpenses = UserDefaults.standard.data(forKey: "expenses") {
            if let decodedExpenses = try? JSONDecoder().decode([ExpenseItem].self, from: savedExpenses) {
                expenses = decodedExpenses
                return
            }
        }
        expenses = []
    }
}

import SwiftUI
import SwiftData



struct ContentView: View {
    @State private var userExpense = UserExpense()
    @State private var showingExpense = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(userExpense.expenses) { item in
                    HStack {
                        VStack {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text(item.value, format: .currency(code: "USD"))
                    }
                }
                .onDelete(perform: deleteAction)
            }
            .navigationTitle("iExpenses")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingExpense = true
                }
            }
            .sheet(isPresented: $showingExpense, content: {
                AddExpense(expense: userExpense)
            })
        }
    }
    
    func deleteAction(at offset: IndexSet) {
        userExpense.expenses.remove(atOffsets: offset)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
