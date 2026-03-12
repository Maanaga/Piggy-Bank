//
//  ChildInfoView.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 12.03.26.
//

import SwiftUI

struct ChildInfoView: View {
    let child: Children
    let onBack: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                headerSection
                bankCardSection
                activePiggyBanksSection
            }
            .padding(.bottom, 80)
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    onBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(FontType.medium.fontType(size: 18))
                        .foregroundStyle(.primary)
                }
            }
        }
    }

    private var headerSection: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color("primaryBlue"))
                    .frame(width: 56, height: 56)
                Text(child.avatarEmoji)
                    .font(FontType.regular.fontType(size: 28))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(child.name)
                    .font(FontType.bold.fontType(size: 22))
                    .foregroundStyle(.primary)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 20)
        .background(Color(.systemBackground))
    }

    private var bankCardSection: some View {
        BankCardView(
            cardTitle: "TBC Card",
            balance: child.balance,
            cardLastFour: ibanLastFour
        )
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    private var ibanLastFour: String {
        let suffix = child.iban.suffix(4)
        return String(suffix)
    }

    private var activePiggyBanksSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Active Piggy Banks")
                    .font(FontType.bold.fontType(size: 18))
                    .foregroundStyle(.primary)
                Spacer()
                Button {
                    // Add new piggy bank
                } label: {
                    Image(systemName: "plus")
                        .font(FontType.medium.fontType(size: 16))
                        .foregroundStyle(.white)
                        .frame(width: 36, height: 36)
                        .background(Color("primaryBlue"))
                        .clipShape(Circle())
                }
            }

            VStack(spacing: 12) {
                GoalCard(
                    title: "New Bicycle",
                    checkpointsCompleted: 4,
                    checkpointsTotal: 6,
                    status: .pending,
                    currentAmount: 175,
                    goalAmount: 250,
                    iconName: "bicycle",
                    accentColor: Color("primaryBlue")
                )
                GoalCard(
                    title: "Art Supplies",
                    checkpointsCompleted: 2,
                    checkpointsTotal: 4,
                    status: .completed,
                    currentAmount: 45,
                    goalAmount: 80,
                    iconName: "paintpalette.fill",
                    accentColor: Color("primaryGreen")
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
    }
}

#Preview {
    ChildInfoView(
        child: Children(
            name: "Sophie Anderson",
            role: .children,
            avatarEmoji: "👧",
            balance: 125.50,
            iban: "GE00XXXX4532"
        ),
        onBack: {}
    )
}
