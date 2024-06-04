//
//  ContentView.swift
//  WeSplit
//
//  Created by Joaquin Etchegaray on 25/4/24.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentageSelected = 0
    
    @FocusState private var isAmountfocused: Bool
    
    var totalAmountPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelectedDouble = Double(tipPercentageSelected)
        
        let tipValue = checkAmount / 100 * tipSelectedDouble
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    var totalAmountPlusTip: Double {
        let tipValue = checkAmount / 100 * Double(tipPercentageSelected)

        let checkAndTip = checkAmount + tipValue
        return checkAndTip
    }
    
    let tipsArray = [10, 15, 20, 25, 0]
    
    var body: some View {
        NavigationStack{
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "UYU"))
                        .keyboardType(.decimalPad)
                        .focused($isAmountfocused)
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<15) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section("How much do you want to tip?"){
                    Picker("Select a tip", selection: $tipPercentageSelected) {
                        ForEach(0..<101, id: \.self) { // precisa el id porque el array contiene elementos que no son facilemente identificables
                            
                            Text($0, format: .percent) // al ser formato percent no precisa estar interpolado
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                    
                
                
                Section("Total amount per person") {
                    Text(totalAmountPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "UYU"))
                }
                .foregroundStyle(tipPercentageSelected == 0 ? .red : .black)
                
                Section("Total amount"){
                    Text(totalAmountPlusTip, format: .currency(code: Locale.current.currency?.identifier ?? "UYU"))
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                if isAmountfocused {
                    Button("Done") {
                        isAmountfocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
