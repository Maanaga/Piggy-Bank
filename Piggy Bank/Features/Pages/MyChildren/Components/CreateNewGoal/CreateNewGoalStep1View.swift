//
//  CreateNewGoalStep1View.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//

import SwiftUI

private let goalIcons: [(name: String, sfSymbol: String)] = [
    ("target", "target"),
    ("bicycle", "bicycle"),
    ("gamepad", "gamecontroller.fill"),
    ("airplane", "airplane"),
    ("phone", "iphone"),
    ("graduation", "graduationcap.fill"),
    ("gift", "gift.fill"),
    ("heart", "heart.fill"),
    ("star", "star.fill"),
    ("trophy", "trophy.fill"),
    ("car", "car.side"),
    ("music", "music.note"),
    ("camera", "camera.fill"),
    ("square", "square"),
    ("palette", "paintpalette.fill"),
    ("tshirt", "tshirt.fill"),
    ("pizza", "fork.knife"),
    ("icecream", "birthday.cake.fill"),
    ("bag", "bag.fill"),
    ("house", "house.fill")
]

struct CreateNewGoalStep1View: View {
    @Binding var goalName: String
    @Binding var selectedIconIndex: Int?
    @Binding var goalAmount: String
    let errors: Step1ValidationErrors

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Goal Name *")
                    .font(FontType.medium.fontType(size: 14))
                    .foregroundStyle(.primary)
                TextField("", text: $goalName)
                    .textFieldStyle(.plain)
                    .padding(12)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(errors.goalName != nil ? Color.red : Color.clear, lineWidth: errors.goalName != nil ? 1 : 0)
                    )
                    .font(FontType.regular.fontType(size: 16))
                if let error = errors.goalName {
                    Text(error)
                        .font(FontType.regular.fontType(size: 12))
                        .foregroundStyle(.red)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Choose an Icon")
                    .font(FontType.medium.fontType(size: 14))
                    .foregroundStyle(.primary)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 5), spacing: 12) {
                    ForEach(Array(goalIcons.enumerated()), id: \.offset) { index, icon in
                        Button {
                            selectedIconIndex = index
                        } label: {
                            Image(systemName: icon.sfSymbol)
                                .font(.system(size: 22))
                                .foregroundStyle(selectedIconIndex == index ? .white : .secondary)
                                .frame(width: 52, height: 52)
                                .background(selectedIconIndex == index ? Color("primaryBlue") : Color(.systemGray5))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                    }
                }
                if let error = errors.icon {
                    Text(error)
                        .font(FontType.regular.fontType(size: 12))
                        .foregroundStyle(.red)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Goal Amount *")
                    .font(FontType.medium.fontType(size: 14))
                    .foregroundStyle(.primary)
                HStack {
                    TextField("0", text: $goalAmount)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.plain)
                        .padding(12)
                        .font(FontType.regular.fontType(size: 16))
                    Text("₾")
                        .font(FontType.medium.fontType(size: 16))
                        .foregroundStyle(.secondary)
                }
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(errors.goalAmount != nil ? Color.red : Color.clear, lineWidth: errors.goalAmount != nil ? 1 : 0)
                )
                Text("Goal: \(goalAmount.isEmpty ? "0" : goalAmount)₾")
                    .font(FontType.regular.fontType(size: 12))
                    .foregroundStyle(.secondary)
                if let error = errors.goalAmount {
                    Text(error)
                        .font(FontType.regular.fontType(size: 12))
                        .foregroundStyle(.red)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
    }
}

#Preview {
    CreateNewGoalStep1View(
        goalName: .constant(""),
        selectedIconIndex: .constant(nil),
        goalAmount: .constant(""),
        errors: Step1ValidationErrors()
    )
}
