//
//  SupporstsLongPress.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 04/05/24.
//

import SwiftUI

// Conform to `PrimitiveButtonStyle` for custom interaction behaviour

struct SupportsLongPress: PrimitiveButtonStyle {
    /// An action to execute on long press
    let longPressAction: () -> Void

    /// Whether the button is being pressed
    @State var isPressed: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        // The "label" as specified when declaring the button
        configuration.label

            // Visual feedback that the button is being pressed
            .brightness(self.isPressed ? 0.1 : 0)
            .onTapGesture {
                // Run the "action" as specified
                // when declaring the button
                configuration.trigger()
            }
            .onLongPressGesture(minimumDuration: 0.2,
                perform: {
                    // Run the action specified
                    // when using this style
                    self.longPressAction()
                },
                onPressingChanged: { pressing in
                    // Use "pressing" to infer whether the button
                    // is being pressed
                    self.isPressed = pressing
                }
            )
    }
}

/// A modifier that applies the `SupportsLongPress` style to buttons
struct SupportsLongPressModifier: ViewModifier {
    let longPressAction: () -> Void
    func body(content: Content) -> some View {
        content.buttonStyle(SupportsLongPress(longPressAction: self.longPressAction))
    }
}

/// Extend the View protocol for a SwiftUI-like shorthand version
extension View {
    func supportsLongPress(longPressAction: @escaping () -> Void) -> some View {
        modifier(SupportsLongPressModifier(longPressAction: longPressAction))
    }
}
