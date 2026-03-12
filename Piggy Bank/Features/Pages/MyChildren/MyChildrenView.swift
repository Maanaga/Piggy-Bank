//
//  MyChildrenView.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 12.03.26.
//

import SwiftUI

struct MyChildrenView: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    headerSection
                    childrenCardsSection
                }
                .padding(.bottom, 80)
            }
            .background(Color(.systemGroupedBackground))

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
            ChildrenCardView(
                name: "Sophie Anderson",
                age: 10,
                avatarEmoji: "👧",
                balance: 125.50,
                cardLastFour: "4532",
                notificationCount: 1
            )
            .onTapGesture {
                // Navigate to child details
            }

            ChildrenCardView(
                name: "Max Anderson",
                age: 8,
                avatarEmoji: "👦",
                balance: 85.00,
                cardLastFour: "7821"
            )
            .onTapGesture {
                // Navigate to child details
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
    NavigationStack {
        MyChildrenView()
    }
}
