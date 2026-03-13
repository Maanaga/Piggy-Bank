import Foundation

struct SignInRequest: Encodable {
    let username: String
    let password: String
}

struct ParentSignInResponseDTO: Decodable {
    let children: [ChildDTO]
    let id: Int
    let name: String
    let surname: String
    let balance: Int
    let role: Int
}

struct SignInResponse: Codable {
    let children: [ChildDTO]
    let role: Int

    enum CodingKeys: String, CodingKey {
        case children, role
    }

    init(children: [ChildDTO], role: Int) {
        self.children = children
        self.role = role
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        children = try c.decode([ChildDTO].self, forKey: .children)
        role = try c.decodeIfPresent(Int.self, forKey: .role) ?? 0
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(children, forKey: .children)
        try c.encode(role, forKey: .role)
    }
}

final class AuthNetworkService {
    private let networkService: NetworkService
    private let decoder = JSONDecoder()

    init(networkService: NetworkService = AppEnvironment.networkService) {
        self.networkService = networkService
    }

    func signIn(username: String, password: String) async throws -> SignInResponse {
        let request = SignInRequest(username: username, password: password)
        let data = try await networkService.postData("api/User", body: request)

        if let parentResponse = try? decoder.decode(ParentSignInResponseDTO.self, from: data) {
            return SignInResponse(children: parentResponse.children, role: parentResponse.role)
        }
        let child = try decoder.decode(ChildDTO.self, from: data)
        return SignInResponse(children: [child], role: child.role)
    }
}
