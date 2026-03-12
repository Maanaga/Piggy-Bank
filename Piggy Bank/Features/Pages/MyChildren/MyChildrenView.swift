//
//  MyChildrenView.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 12.03.26.
//

import SwiftUI

struct MyChildrenView: View {
    let children: [Children]
    let onChildSelected: (Children) -> Void

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    headerSection
                    childrenCardsSection
                }
                .padding(.bottom, 80)
            }
            .background(Color.white)

            //infoFAB
        }
        .navigationBarHidden(true)
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("My Children")
                        .font(FontType.bold.fontType(size: 28))
                        .foregroundStyle(.primary)
                    Text("Manage your children's piggy banks.")
                        .font(FontType.regular.fontType(size: 14))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button {
                    // Notifications action
                } label: {
                    Image(systemName: "bell")
                        .font(FontType.medium.fontType(size: 20))
                        .foregroundStyle(.primary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 60)
        .padding(.bottom, 24)
        .background(Color(.systemBackground))
    }

    private var childrenCardsSection: some View {
        VStack(spacing: 12) {
            ForEach(Array(children.enumerated()), id: \.offset) { index, child in
                ChildrenCardView(
                    name: child.name,
                    avatarEmoji: child.avatarEmoji,
                    balance: child.balance,
                    cardLastFour: String(child.iban.suffix(4)),
                    notificationCount: index == 0 ? 1 : nil
                )
                .onTapGesture {
                    onChildSelected(child)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    private var infoFAB: some View {
        Button {
            // Info action
        } label: {
            Image(systemName: "info")
                .font(FontType.medium.fontType(size: 20))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(Color("primaryBlue"))
                .clipShape(Circle())
        }
        .padding(.trailing, 20)
        .padding(.bottom, 100)
    }
}

#Preview {
    MyChildrenView(
        children: [
            Children(name: "Sophie Anderson", role: .children, avatarEmoji: "👧", balance: 125.50, iban: "GE00XXXX4532"),
            Children(name: "Max Anderson", role: .children, avatarEmoji: "👦", balance: 85.00, iban: "GE00XXXX7821")
        ],
        onChildSelected: { _ in }
    )
}
