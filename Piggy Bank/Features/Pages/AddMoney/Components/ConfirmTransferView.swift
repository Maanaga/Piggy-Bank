//
//  ConfirmTransferView.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//

import SwiftUI

struct ConfirmTransferView: View {
    let amount: Int
    let fromText: String
    let toText: String
    let newBalance: Int
    var errorMessage: String? = nil
    var isConfirming: Bool = false
    let onCancel: () -> Void
    let onConfirm: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Text("Confirm Transfer")
                .font(FontType.bold.fontType(size: 22))
                .foregroundStyle(.primary)
                .padding(.top, 24)
                .padding(.bottom, 28)

            VStack(spacing: 0) {
                confirmRow(label: "Amount", value: "\(amount)₾")
                Divider()
                    .padding(.vertical, 14)
                confirmRow(label: "From", value: fromText)
                Divider()
                    .padding(.vertical, 14)
                confirmRow(label: "To", value: toText)
                Divider()
                    .padding(.vertical, 14)
                confirmRow(label: "New Balance", value: "\(newBalance)₾", valueColor: Color("primaryBlue"))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(FontType.regular.fontType(size: 14))
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
            }

            HStack(spacing: 12) {
                Button(action: onCancel) {
                    Text("Cancel")
                        .font(FontType.medium.fontType(size: 16))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(.systemGray5))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .disabled(isConfirming)

                Button(action: onConfirm) {
                    HStack(spacing: 6) {
                        if isConfirming {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Drop it in!")
                            Text("💰")
                                .font(FontType.regular.fontType(size: 16))
                        }
                    }
                    .font(FontType.bold.fontType(size: 16))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color("primaryBlue"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .disabled(isConfirming)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: 320)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
    }

    private func confirmRow(label: String, value: String, valueColor: Color = .primary) -> some View {
        HStack {
            Text(label)
                .font(FontType.regular.fontType(size: 16))
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(FontType.medium.fontType(size: 16))
                .foregroundStyle(valueColor)
        }
    }
}
