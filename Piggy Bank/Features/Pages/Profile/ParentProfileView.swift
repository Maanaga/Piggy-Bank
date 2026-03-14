import SwiftUI

struct ParentProfileView: View {
    @State private var profile: ParentProfile?
    private let parentId: Int?
    private let childInfoService = ChildInfoNetworkService()

    init(profile: ParentProfile?, parentId: Int? = nil) {
        _profile = State(initialValue: profile)
        self.parentId = parentId
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                headerSection
                bankCardSection
            }
            .padding(.bottom, 80)
        }
        .refreshable { await refreshProfile() }
        .background(Color(.systemBackground))
        .navigationBarHidden(true)
    }

    private func refreshProfile() async {
        guard let parentId else { return }
        do {
            let info = try await childInfoService.getChildInfo(childId: parentId)
            let displayName = info.surname.isEmpty ? info.name : "\(info.name) \(info.surname)"
            await MainActor.run {
                profile = ParentProfile(name: displayName, balance: info.balance, iban: info.iban)
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
                    Text(profile?.name ?? "Parent")
                        .font(FontType.bold.fontType(size: 22))
                        .foregroundStyle(.primary)
                    Text("Parent Account")
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
            balance: Decimal(profile?.balance ?? 0),
            iban: profile?.iban ?? ""
        )
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

#Preview {
    ParentProfileView(
        profile: ParentProfile(name: "Simon Petrikov", balance: 4700, iban: "GE45TB7964511000000001"),
        parentId: 1
    )
}
