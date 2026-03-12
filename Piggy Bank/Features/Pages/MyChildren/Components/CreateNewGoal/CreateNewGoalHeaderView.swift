//
//  CreateNewGoalHeaderView.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//

import SwiftUI

struct CreateNewGoalHeaderView: View {
    let childName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Create New Goal")
                .font(FontType.bold.fontType(size: 24))
                .foregroundStyle(.primary)
            Text("Setting up piggy bank for \(childName)")
                .font(FontType.regular.fontType(size: 14))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 16)
        .background(Color(.systemBackground))
    }
}

#Preview {
    CreateNewGoalHeaderView(childName: "Sophie Anderson")
}
