//
//  ChildInfoView.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 12.03.26.
//

import SwiftUI

struct ChildInfoView: View {
    @ObservedObject var viewModel: MyChildrenViewModel

    var body: some View {
        Group {
            if let child = viewModel.selectedChild {
                mainContent(child: child)
            } else {
                Color.clear
                    .onAppear { viewModel.onBack?() }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(false)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    viewModel.onBack?()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(FontType.medium.fontType(size: 18))
                        .foregroundStyle(.primary)
                }
            }
        }
        .sheet(isPresented: $viewModel.showCreateGoalSheet) {
            CreateNewGoalSheet(viewModel: viewModel)
        }
    }

    private func mainContent(child: Children) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                headerSection(child: child)
                bankCardSection(child: child)
                activePiggyBanksSection
            }
            .padding(.bottom, 80)
        }
        .background(Color.white)
        .navigationTitle(child.name)
    }

    private func headerSection(child: Children) -> some View {
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

    private func bankCardSection(child: Children) -> some View {
        BankCardView(
            cardTitle: "TBC Card",
            balance: child.balance,
            cardLastFour: String(child.iban.suffix(4))
        )
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    private var activePiggyBanksSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Active Piggy Banks")
                    .font(FontType.bold.fontType(size: 18))
                    .foregroundStyle(.primary)
                Spacer()
                Button {
                    viewModel.showCreateGoalSheet = true
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
    let vm = MyChildrenViewModel(children: [
        Children(name: "Sophie Anderson", role: .children, avatarEmoji: "👧", balance: 125.50, iban: "GE00XXXX4532")
    ])
    vm.selectChild(vm.children[0])
    return ChildInfoView(viewModel: vm)
}
