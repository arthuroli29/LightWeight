//
//  RoundedBorder.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 15/08/24.
//

import SwiftUI

struct RoundedBorderModifier: ViewModifier {
    let cornerRadius: CGFloat
    let color: Color
    let lineWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay(RoundedRectangle(cornerRadius: cornerRadius).strokeBorder(color, lineWidth: lineWidth))
    }
}

extension View {
    func roundedBorder(cornerRadius: CGFloat = .infinity, color: Color = .gray, lineWidth: CGFloat = 1) -> some View {
        modifier(RoundedBorderModifier(cornerRadius: cornerRadius, color: color, lineWidth: lineWidth))
    }
}
