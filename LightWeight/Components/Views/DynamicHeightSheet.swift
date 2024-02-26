//
//  DynamicHeightSheet.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 25/02/24.
//

import Foundation
import SwiftUI

struct DynamicHeightSheet<Content: View>: View {
    let content: () -> Content
    @State private var sheetHeight: CGFloat = .zero
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        content()
            .modifier(GetHeightModifier(height: $sheetHeight))
            .fixedSize(horizontal: false, vertical: true)
            .presentationDetents([.height(sheetHeight)])
    }
    
}
