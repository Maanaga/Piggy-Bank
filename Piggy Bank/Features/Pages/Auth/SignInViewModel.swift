import Foundation
import Combine

final class SignInViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    var onSignInSuccess: ((SignInResponse) -> Void)?

    private let authService: AuthNetworkService

    init(authService: AuthNetworkService = AuthNetworkService()) {
        self.authService = authService
    }

    func signIn() {
        let user = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let pass = password.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !user.isEmpty, !pass.isEmpty else {
            errorMessage = "Please enter username and password."
            return
        }

        errorMessage = nil
        isLoading = true
        Task { @MainActor in
            defer { isLoading = false }
            do {
                let response = try await authService.signIn(username: user, password: pass)
                onSignInSuccess?(response)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
