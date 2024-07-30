//
//  PickerSheetView.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 02/05/24.
//

import SwiftUI

struct PickerSheetView<T: Hashable>: View {
    init(isPresented: Binding<Bool>, values: [T], initialValue: T, didSelect: @escaping (T) -> Void, didCancel: @escaping () -> Void) {
        self._isPresented = isPresented
        self.selectedValue = initialValue
        self.values = values
        self.didSelect = didSelect
        self.didCancel = didCancel
    }

    @Binding var isPresented: Bool
    @State var selectedValue: T
    let values: [T]
    let didCancel: () -> Void
    let didSelect: (T) -> Void

    var body: some View {
        DynamicHeightSheet {
            VStack(spacing: 0) {
                HStack {
                    Button {
                        didCancel()
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
            .onChange(of: selectedValue) { newValue in
                didSelect(newValue)
            }
        }
    }
}


#Preview {
    Color.blue
        .ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            PickerSheetView(
                isPresented: .constant(true),
                values: Array(0...20),
                initialValue: 10,
                didSelect: { _ in },
                didCancel: {}
            )
        }
}
