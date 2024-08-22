//
//  SearchTextField.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 19/08/24.
//

import SwiftUI

struct SearchTextField: View {
    @Binding var text: String
    var placeholder: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .padding(.leading, 15)
                .padding(.trailing, 10)

            TextField(placeholder, text: $text)
                .padding(.vertical, 10)
                .font(.system(size: 14, weight: .semibold))
                .background(Color.clear)
                .padding(.trailing, 5)
        }
        .frame(height: 50)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.gray.opacity(0.25))
                .roundedBorder(cornerRadius: 10, color: text.isEmpty ? .clear : .accent, lineWidth: 2)
        )
        .animation(.easeInOut(duration: 0.3), value: text.isEmpty)
    }
}
