//
//  ContentView.swift
//  ConvertTool
//
//  Created by Ngô Nam on 07/01/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var amount = 100.0
    @State private var inputUnit: Dimension = UnitLength.kilometers
    @State private var outputUnit: Dimension = UnitLength.meters
    @State private var selectedUnit = 0
    @FocusState private var isAmountFocused: Bool
    
    let conversions = ["Distance", "Mass", "Temperature", "Time"]
    let unitTypes = [
        [UnitLength.kilometers, UnitLength.meters, UnitLength.miles, UnitLength.feet, UnitLength.inches],
        [UnitMass.kilograms, UnitMass.pounds, UnitMass.grams, UnitMass.ounces],
        [UnitTemperature.celsius, UnitTemperature.fahrenheit, UnitTemperature.kelvin],
        [UnitDuration.hours, UnitDuration.minutes, UnitDuration.seconds]
    ]
    
    var formatter: MeasurementFormatter {
        let mf = MeasurementFormatter()
        mf.unitOptions = .providedUnit
        mf.unitStyle = .long
        return mf
    }
    
    func result() -> String {
        let inputAmount = Measurement(value: amount, unit: inputUnit)
        let outputAmount = inputAmount.converted(to: outputUnit)
        return formatter.string(from: outputAmount).capitalized
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $amount, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($isAmountFocused)
                } header: {
                    Text("Amount to convert")
                }
                
                Picker("Conversion", selection: $selectedUnit) {
                    ForEach(0..<conversions.count, id: \.self) {
                        Text(conversions[$0])
                    }
                }
                .pickerStyle(.segmented)
                
                Picker("Convert from", selection: $inputUnit) {
                    ForEach(unitTypes[selectedUnit], id: \.self) {
                        Text(formatter.string(from: ($0)).capitalized)
                    }
                }
                
                Picker("Convert to", selection: $outputUnit) {
                    ForEach(unitTypes[selectedUnit], id: \.self) {
                        Text(formatter.string(from: $0).capitalized)
                    }
                }
                
                Section {
                    Text(result())
                } header: {
                    Text("result")
                }
            }
            .navigationTitle("Converter")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isAmountFocused = false
                    }
                }
            }
            .onChange(of: selectedUnit) { newSelection in
                let units = unitTypes[newSelection]
                inputUnit = units[0]
                outputUnit = units[1]
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
