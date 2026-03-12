import SwiftUI

struct SignInView: View {
    var onSignIn: () -> Void
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ZStack {
            Color.primaryBlue
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    cardContent
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                .padding(.bottom, 40)
            }
        }
    }
    
    private var cardContent: some View {
        VStack(alignment: .leading, spacing: 24) {
            headerSection
            usernameField
            passwordField
            signInButton
        }
        .padding(28)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Sign In")
                .font(FontType.bold.fontType(size: 28))
                .foregroundStyle(.primary)
            Text("Welcome to Piggy Bank")
                .font(FontType.regular.fontType(size: 16))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 8)
    }
    
    private var usernameField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Username")
                .font(FontType.medium.fontType(size: 14))
                .foregroundStyle(.primary)
            HStack(spacing: 12) {
                Image(systemName: "person")
                    .font(FontType.medium.fontType(size: 16))
                    .foregroundStyle(.secondary)
                TextField("Enter your username", text: $username)
                    .font(FontType.regular.fontType(size: 16))
            }
            .padding(12)
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    private var passwordField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Password")
                .font(FontType.medium.fontType(size: 14))
                .foregroundStyle(.primary)
            HStack(spacing: 12) {
                Image(systemName: "lock")
                    .font(FontType.medium.fontType(size: 16))
                    .foregroundStyle(.secondary)
                SecureField("Enter your password", text: $password)
                    .font(FontType.regular.fontType(size: 16))
            }
            .padding(12)
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    private var signInButton: some View {
        Button {
            onSignIn()
        } label: {
            Text("Sign In")
                .font(FontType.bold.fontType(size: 18))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    Color.primaryBlue
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .padding(.top, 8)
    }
}

#Preview {
    SignInView(onSignIn: {})
}
