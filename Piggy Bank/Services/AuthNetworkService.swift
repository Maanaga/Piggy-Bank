import Foundation

struct SignInRequest: Encodable {
    let username: String
    let password: String
}

struct SignInResponse: Decodable {
    let children: [ChildDTO]
}

struct PiggyBankRefDTO: Decodable {
    //TODO: piggybank decode
}


final class AuthNetworkService {
    private let networkService: NetworkService

    init(networkService: NetworkService = AppEnvironment.networkService) {
        self.networkService = networkService
    }

    func signIn(username: String, password: String) async throws -> SignInResponse {
        let request = SignInRequest(username: username, password: password)
        return try await networkService.post(
            "api/User",
            body: request,
            as: SignInResponse.self
        )
    }
}
