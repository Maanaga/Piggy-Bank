import SwiftUI

struct SignInView: View {
    @StateObject private var viewModel = SignInViewModel()
    var onSignIn: (SignInResponse) -> Void

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
        .onAppear { viewModel.onSignInSuccess = onSignIn }
    }
    
    private var cardContent: some View {
        VStack(alignment: .leading, spacing: 24) {
            headerSection
            usernameField
            passwordField
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(FontType.regular.fontType(size: 14))
                    .foregroundStyle(.red)
            }
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
                TextField("Enter your username", text: $viewModel.username)
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
                SecureField("Enter your password", text: $viewModel.password)
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
            viewModel.signIn()
        } label: {
            HStack(spacing: 8) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Sign In")
                        .font(FontType.bold.fontType(size: 18))
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.primaryBlue)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isLoading)
        .padding(.top, 8)
    }
}

#Preview {
    SignInView(onSignIn: { _ in })
}
