//
//  PickerSheetView.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 02/05/24.
//

import SwiftUI

struct PickerSheetView<T: Hashable>: View {
    @Binding var selectedValue: T
    @Binding var isPresented: Bool
    let previousValue: T?
    let values: [T]
    
    var body: some View {
        DynamicHeightSheet {
            VStack(spacing: 0) {
                
                HStack {
                    Button {
                        if let previousValue {
                            selectedValue = previousValue
                        }
                        isPresented = false
                    } label: {
                        Text("Cancel")
                    }
                    
                    Spacer()
                    
                    Button {
                        isPresented = false
                    } label: {
                        Text("Done")
                    }
                    
                }
                .padding()
                
                Picker("Picker", selection: $selectedValue) {
                    ForEach(values, id: \.self) { item in
                        Text("\(item)")
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: .infinity)
            }
        }
    }
}


#Preview {
    Color.blue
        .ignoresSafeArea()
        .sheet(isPresented: .constant(true), content: {
            PickerSheetView(selectedValue: .constant(1), isPresented: .constant(true), previousValue: nil, values: Array(0...20))
        })
}
