//
//  Image+Adds(Modifiers).swift
//  LightWeight
//
//  Created by Arthur Oliveira on 04/05/24.
//

import SwiftUI

extension Image {
    func roundedStyle() -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: 15, height: 15)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background {
                Color.gray
                    .opacity(0.25)
                    .cornerRadius(8)
            }
    }
}
