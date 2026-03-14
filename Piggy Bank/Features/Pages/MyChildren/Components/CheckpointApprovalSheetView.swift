import SwiftUI

struct CheckpointApprovalSheetView: View {
    let approval: PendingCheckpointApproval
    let isApproving: Bool
    let onApprove: () -> Void
    let onReject: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            iconSection
            titleSection
            detailsCard
            actionButtons
        }
        .padding(.bottom, 32)
        .background(Color(.systemBackground))
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }

    private var iconSection: some View {
        ZStack {
            Circle()
                .fill(Color.green.opacity(0.75))
                .frame(width: 80, height: 80)
            Image(systemName: approval.iconName)
                .font(FontType.bold.fontType(size: 32))
                .foregroundStyle(.white)
        }
        .padding(.top, 36)
    }

    private var titleSection: some View {
        VStack(spacing: 6) {
            Text("Checkpoint Reached")
                .font(FontType.bold.fontType(size: 24))
                .foregroundStyle(.primary)
            Text("Level \(approval.level) checkpoint for \(approval.goalTitle)")
                .font(FontType.regular.fontType(size: 15))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 16)
        .padding(.horizontal, 24)
    }

    private var detailsCard: some View {
        VStack(spacing: 0) {
            detailRow(label: "Piggy Bank", value: approval.goalTitle)
            Divider().padding(.vertical, 12)
            detailRow(label: "Level", value: "Level \(approval.level)")
            Divider().padding(.vertical, 12)
            detailRow(label: "Amount Saved", value: "\(approval.amountSaved) \u{20BE}")
            Divider().padding(.vertical, 12)
            detailRow(label: "Your Contribution", value: "\(approval.prizeAmount) \u{20BE}")
            Divider().padding(.vertical, 12)
            detailRow(label: "Reward", value: "\(approval.rewardPoints) pts")
        }
        .padding(16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 24)
        .padding(.top, 24)
    }

    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(FontType.regular.fontType(size: 15))
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(FontType.bold.fontType(size: 15))
                .foregroundStyle(.primary)
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button(action: onReject) {
                Text("Reject")
                    .font(FontType.bold.fontType(size: 16))
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
            .disabled(isApproving)

            Button(action: onApprove) {
                HStack(spacing: 6) {
                    if isApproving {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Approve")
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
            .disabled(isApproving)
        }
        .padding(.horizontal, 24)
        .padding(.top, 28)
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            CheckpointApprovalSheetView(
                approval: PendingCheckpointApproval(
                    piggyBankId: 1,
                    checkpointId: 1,
                    level: 1,
                    goalTitle: "Playstation",
                    amountSaved: 150,
                    rewardPoints: 150,
                    prizeAmount: 50,
                    iconName: "gift.fill",
                    childId: 1,
                    childIBAN: "GE00XXXX1234"
                ),
                isApproving: false,
                onApprove: {},
                onReject: {},
                onDismiss: {}
            )
        }
}
