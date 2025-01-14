//
//  Button+Adds.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 13/01/25.
//

import SwiftUI

struct NoTapAnimationStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // Make the whole button surface tappable. Without this only content in the label is tappable and not whitespace. Order is important so add it before the tap gesture
            .contentShape(Rectangle())
            .onTapGesture(perform: configuration.trigger)
    }
}

extension Button {
    @ViewBuilder
    func removingTapAnimation(_ bool: Bool) -> some View {
        if bool {
            buttonStyle(NoTapAnimationStyle())
        } else {
            self
        }
    }
}
