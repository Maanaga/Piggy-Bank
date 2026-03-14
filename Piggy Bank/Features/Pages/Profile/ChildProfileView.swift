import SwiftUI

struct ChildProfileView: View {
    @State private var name: String
    @State private var balance: Decimal
    @State private var iban: String
    @State private var showLogoutConfirmation = false
    private let childId: Int?
    private let onLogout: (() -> Void)?
    private let childInfoService = ChildInfoNetworkService()

    init(child: Children, onLogout: (() -> Void)? = nil) {
        _name = State(initialValue: child.name)
        _balance = State(initialValue: child.balance)
        _iban = State(initialValue: child.iban)
        self.childId = child.id
        self.onLogout = onLogout
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                headerSection
                bankCardSection
                logoutSection
            }
            .padding(.bottom, 80)
        }
        .refreshable { await refreshProfile() }
        .background(Color(.systemBackground))
        .navigationBarHidden(true)
        .alert("Log Out", isPresented: $showLogoutConfirmation) {
            Button("Log Out", role: .destructive) { onLogout?() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to log out?")
        }
    }

    private func refreshProfile() async {
        guard let childId else { return }
        do {
            let info = try await childInfoService.getChildInfo(childId: childId)
            let displayName = info.surname.isEmpty ? info.name : "\(info.name) \(info.surname)"
            await MainActor.run {
                name = displayName
                balance = Decimal(info.balance)
                iban = info.iban
            }
        } catch {}
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color("primaryBlue"))
                        .frame(width: 56, height: 56)
                    Image(systemName: "person.fill")
                        .font(FontType.medium.fontType(size: 24))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(FontType.bold.fontType(size: 22))
                        .foregroundStyle(.primary)
                    Text("Child Account")
                        .font(FontType.regular.fontType(size: 14))
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 60)
        .padding(.bottom, 20)
    }

    private var bankCardSection: some View {
        BankCardView(
            cardTitle: "TBC Card",
            balance: balance,
            iban: iban
        )
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    private var logoutSection: some View {
        Button {
            showLogoutConfirmation = true
        } label: {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(FontType.medium.fontType(size: 16))
                Text("Log Out")
                    .font(FontType.medium.fontType(size: 16))
            }
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.red.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal, 20)
        .padding(.top, 32)
    }
}

#Preview {
    ChildProfileView(
        child: Children(id: 1, name: "Marceline Petrikov", role: .children, avatarEmoji: "👧", balance: 1500, iban: "GE45TB7964511000000001")
    )
}
