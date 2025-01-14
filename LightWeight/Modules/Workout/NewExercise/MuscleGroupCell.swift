//
//  MuscleGroupCellView.swift
//  LightWeight
//
//  Created by Arthur Oliveira on 13/01/25.
//

import SwiftUI

struct MuscleGroupCell: View {
    let muscle: MuscleGroup
    let selected: Bool
    let onSelect: () -> Void
    let enabled: Bool

    var body: some View {
        VStack(spacing: 15) {
            Button {
                withAnimation {
                    if enabled {
                        onSelect()
                    }
                }
            } label: {
                ZStack {
                    Color.secondary
                        .frame(width: 160, height: 160)
                        .cornerRadius(30)
                        .roundedBorder(
                            cornerRadius: 30,
                            color: selected ? Color.red : Color.gray,
                            lineWidth: selected ? 4 : 1.5
                        )
                        .shadow(color: Color.red.opacity(selected ? 0.5 : 0), radius: 20, x: 0, y: 0)

                    Image(systemName: "alarm")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .tint(.red)
                        .frame(width: 70, height: 70)
                        .foregroundStyle(Color.red.opacity(selected ? 0.9 : 0.6))
                }
            }
            .removingTapAnimation(true)

            Text(muscle.name ?? "")
                .font(.system(size: 15))
                .foregroundColor(selected ? .white : .gray)
        }
        .opacity(enabled ? 1 : 0.5)
    }
}

#Preview {
    @Previewable @State var isSelected = true
    MuscleGroupCell(
        muscle: {
        let muscle = MuscleGroup(context: DataManager.shared.managedObjectContext)
        muscle.name = "Chest"
        muscle.id = UUID()
        return muscle
    }(),
        selected: isSelected,
        onSelect: { isSelected.toggle() },
        enabled: true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primary)
}
