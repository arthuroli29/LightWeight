//
//  NewExerciseSelectionView.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 27/07/24.
//

import SwiftUI

struct NewExerciseSelectionView: View {
    let title: String
    @ObservedObject var viewModel: NewExerciseViewModel
    let selectionType: NewExerciseSelectionType

    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 22))

            Spacer()
                .frame(height: 10)

            HStack {
                ForEach(viewModel.sets, id: \.order) { set in
                    Button {
                        viewModel.selectOne(selectionType, at: set.order)
                    } label: {
                        Text("\(set[keyPath: selectionType.keyPath])")
                            .font(.system(size: 25))
                            .foregroundColor(viewModel.selected?.type == selectionType &&
                                (viewModel.selected?.selectedIndex == nil ||
                                viewModel.selected?.selectedIndex == set.order) ?
                                .accent :
                                .primary)
                            .frame(maxWidth: .infinity)
                    }
                    .supportsLongPress {
                        viewModel.selectAll(selectionType)
                    }
                }
            }
        }
    }
}

#Preview {
    NewExerciseSelectionView(title: "test", viewModel: .init(), selectionType: .repCount)
}
