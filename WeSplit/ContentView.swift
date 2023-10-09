//
//  ContentView.swift
//  WeSplit
//
//  Created by Michael Welker on 2023-07-23.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool
    
    @Environment(\.colorScheme) var colorScheme // goes DOWN the heirarchy
    
    let tipPercentages = [0, 10, 15, 20, 25]
    
    var currencyId = FloatingPointFormatStyle<Double>.Currency.currency(code: Locale.current.currency?.identifier ?? "USD")
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        
        let tipValue = checkAmount * (tipSelection / 100)
        let grandTotal = checkAmount + tipValue
        
        return grandTotal / peopleCount
    }
    
    var tipAmount: Double {
        return Double(tipPercentage) / 100 * checkAmount
    }
    
    var tipAmountString: String {
        return tipAmount.formatted(currencyId)
    }
    
    var billTotal: String {
        return checkAmount.formatted(currencyId)
    }
    
    var grandTotal: String {
        return (checkAmount + tipAmount).formatted(currencyId)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: currencyId)
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0)")
                        }
                    }
                } header: {
                    Text("bill total:")
                }
                Section {
                    VStack {
                        Picker("Tip percentage", selection: $tipPercentage) {
                            ForEach(tipPercentages, id: \.self) {
                                Text($0, format: .percent)
                            }
                        }
                        .pickerStyle(.segmented)
                        Picker("custom tip", selection: $tipPercentage) {
                            ForEach(0..<101) {
                                Text("\($0)%")
                            }
                        }
                    }
                } header: {
                    Text("Tip Amount:")
                }
                Section {
                    VStack {
                        Text("Bill: \(billTotal)")
                        Text("+ Tip: \(tipAmountString)")
                        Divider()
                        Text("Total: \(grandTotal)")
                    }
                } header: {
                    Text("Summary:")
                }
                Section {
                    Text(totalPerPerson, format: currencyId)
                        .foregroundColor(tipPercentage == 0 ? .red : .black)
                } header: {
                    Text("each person owes:")
                }
            }
            .navigationTitle("WeSplit") // SwiftUI preference, preference keys
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
