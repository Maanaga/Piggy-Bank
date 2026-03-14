//
//  AddMoneyAmountSectionView.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//

import SwiftUI

struct AddMoneyAmountSectionView: View {
    @ObservedObject var viewModel: AddMoneyViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("How much?")
                .font(FontType.medium.fontType(size: 14))
                .foregroundStyle(.secondary)

            Text("\(viewModel.displayAmount)₾")
                .font(FontType.bold.fontType(size: 36))
                .foregroundStyle(Color("primaryBlue"))

            sliderSection

            HStack(spacing: 12) {
                quickAmountButton(5)
                quickAmountButton(10)
                quickAmountButton(20)
                customButton
            }

            Divider()
                .padding(.vertical, 4)

            if viewModel.isCustomMode {
                TextField("0", text: $viewModel.customAmountText)
                    .font(FontType.regular.fontType(size: 18))
                    .keyboardType(.numberPad)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }

    private var sliderSection: some View {
        let maxAmount = Double(viewModel.remainingAmount)
        let percentage = maxAmount > 0 ? viewModel.sliderValue / maxAmount * 100 : 0

        return VStack(spacing: 8) {
            AmountSlider(value: $viewModel.sliderValue, range: 0...max(maxAmount, 1), isActive: viewModel.isSliderMode) {
                viewModel.activateSlider()
            }

            HStack {
                Text("0₾")
                    .font(FontType.regular.fontType(size: 12))
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(Int(percentage))%")
                    .font(FontType.medium.fontType(size: 12))
                    .foregroundStyle(Color("primaryBlue"))
                Spacer()
                Text("\(viewModel.remainingAmount)₾")
                    .font(FontType.regular.fontType(size: 12))
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func quickAmountButton(_ amount: Int) -> some View {
        let isSelected = !viewModel.isCustomMode && viewModel.selectedAmount == amount
        return Button {
            viewModel.selectQuickAmount(amount)
        } label: {
            Text("\(amount)₾")
                .font(FontType.medium.fontType(size: 16))
                .foregroundStyle(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isSelected ? Color("primaryBlue") : Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }

    private var customButton: some View {
        let isSelected = viewModel.isCustomMode
        return Button {
            viewModel.selectCustom()
        } label: {
            Text("Custom")
                .font(FontType.medium.fontType(size: 16))
                .foregroundStyle(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isSelected ? Color("primaryBlue") : Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }
}
