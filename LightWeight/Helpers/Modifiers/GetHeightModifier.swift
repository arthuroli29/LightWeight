//
//  GetHeightModifier.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 22/02/24.
//

import Foundation
import SwiftUI

struct GetHeightModifier: ViewModifier {
    @Binding var height: CGFloat

    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geo -> Color in
                DispatchQueue.main.async {
                    height = geo.size.height
                }
                return Color.clear
            }
        )
    }
}
