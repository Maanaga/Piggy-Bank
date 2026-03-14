import SwiftUI

struct ParentProfileView: View {
    let profile: ParentProfile?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                headerSection
                bankCardSection
            }
            .padding(.bottom, 80)
        }
        .background(Color(.systemBackground))
        .navigationBarHidden(true)
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
        profile: ParentProfile(name: "Simon Petrikov", balance: 4700, iban: "GE45TB7964511000000001")
    )
}
