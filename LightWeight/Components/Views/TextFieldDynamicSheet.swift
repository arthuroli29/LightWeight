//
//  TextFieldDynamicSheet.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 02/03/24.
//

import SwiftUI

struct TextFieldDynamicSheet: View {
    init(text: Binding<String>, onDone: @escaping (() -> Void), onCancel: @escaping (() -> Void)) {
        self._text = text
        self.onDone = onDone
        self.onCancel = onCancel
    }
    @Binding var text: String
    let onDone: (() -> Void)
    let onCancel: (() -> Void)
    
    var body: some View {
        DynamicHeightSheet {
            VStack {
                
                Spacer(minLength: 10)
                
                TextField("Routine name", text: $text, axis: .vertical)
                    .padding(10)
                    .background(Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 10)
                
                Spacer(minLength: 40)
                
                Button {
                    onDone()
                } label: {
                    Text("Done")
                        .frame(maxWidth: .infinity)
                        .frame(height: 25)
                }
                .padding(.horizontal)
                .buttonStyle(.borderedProminent)
                
                Spacer(minLength: 15)
                
                Button(role: .destructive) {
                    onCancel()
                } label: {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .frame(height: 25)
                }
                .padding(.horizontal)
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .presentationDragIndicator(.visible)
    }
}
