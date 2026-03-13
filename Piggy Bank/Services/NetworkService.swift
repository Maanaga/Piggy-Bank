import Foundation

struct NetworkConfiguration {
    var baseURL: URL?
    var defaultHeaders: [String: String]
    var timeout: TimeInterval

    init(
        baseURL: URL? = nil,
        defaultHeaders: [String: String] = ["Content-Type": "application/json"],
        timeout: TimeInterval = 30
    ) {
        self.baseURL = baseURL
        self.defaultHeaders = defaultHeaders
        self.timeout = timeout
    }
}

final class NetworkService {
    private(set) var configuration: NetworkConfiguration
    private let session: URLSession
    private let decoder: JSONDecoder

    init(
        configuration: NetworkConfiguration,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.configuration = configuration
        self.session = session
        self.decoder = decoder
    }

    func updateBaseURL(_ newBaseURL: URL?) {
        configuration.baseURL = newBaseURL
    }

    func updateDefaultHeaders(_ headers: [String: String]) {
        configuration.defaultHeaders = headers
    }

    func request<T: Decodable>(_ endpoint: Endpoint, as type: T.Type = T.self) async throws -> T {
        let request = try buildRequest(from: endpoint)
        let (data, response) = try await perform(request)

        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }

    func request(_ endpoint: Endpoint) async throws -> Data {
        let request = try buildRequest(from: endpoint)
        let (data, _) = try await perform(request)
        return data
    }

    func requestVoid(_ endpoint: Endpoint) async throws {
        let request = try buildRequest(from: endpoint)
        _ = try await perform(request)
    }

    func get<T: Decodable>(
        _ path: String,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        as type: T.Type = T.self
    ) async throws -> T {
        let endpoint = APIEndpoint(
            path: path,
            method: .get,
            headers: headers,
            queryItems: queryItems
        )
        return try await request(endpoint, as: type)
    }

    func post<T: Decodable, Body: Encodable>(
        _ path: String,
        body: Body,
        headers: [String: String] = [:],
        as type: T.Type = T.self
    ) async throws -> T {
        let endpoint = try APIEndpoint(
            path: path,
            method: .post,
            headers: headers,
            jsonBody: body
        )
        return try await request(endpoint, as: type)
    }

    func postData<Body: Encodable>(
        _ path: String,
        body: Body,
        headers: [String: String] = [:]
    ) async throws -> Data {
        let endpoint = try APIEndpoint(
            path: path,
            method: .post,
            headers: headers,
            jsonBody: body
        )
        return try await request(endpoint)
    }

    func post<Body: Encodable>(
        _ path: String,
        body: Body,
        headers: [String: String] = [:]
    ) async throws {
        let endpoint = try APIEndpoint(
            path: path,
            method: .post,
            headers: headers,
            jsonBody: body
        )
        try await requestVoid(endpoint)
    }

    func put<T: Decodable, Body: Encodable>(
        _ path: String,
        body: Body,
        headers: [String: String] = [:],
        as type: T.Type = T.self
    ) async throws -> T {
        let endpoint = try APIEndpoint(
            path: path,
            method: .put,
            headers: headers,
            jsonBody: body
        )
        return try await request(endpoint, as: type)
    }

    func put<Body: Encodable>(
        _ path: String,
        body: Body,
        headers: [String: String] = [:]
    ) async throws {
        let endpoint = try APIEndpoint(
            path: path,
            method: .put,
            headers: headers,
            jsonBody: body
        )
        try await requestVoid(endpoint)
    }

    func patch<T: Decodable, Body: Encodable>(
        _ path: String,
        body: Body,
        headers: [String: String] = [:],
        as type: T.Type = T.self
    ) async throws -> T {
        let endpoint = try APIEndpoint(
            path: path,
            method: .patch,
            headers: headers,
            jsonBody: body
        )
        return try await request(endpoint, as: type)
    }

    func patch<Body: Encodable>(
        _ path: String,
        body: Body,
        headers: [String: String] = [:]
    ) async throws {
        let endpoint = try APIEndpoint(
            path: path,
            method: .patch,
            headers: headers,
            jsonBody: body
        )
        try await requestVoid(endpoint)
    }

    func delete(
        _ path: String,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:]
    ) async throws {
        let endpoint = APIEndpoint(
            path: path,
            method: .delete,
            headers: headers,
            queryItems: queryItems
        )
        try await requestVoid(endpoint)
    }

    func delete<T: Decodable>(
        _ path: String,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        as type: T.Type = T.self
    ) async throws -> T {
        let endpoint = APIEndpoint(
            path: path,
            method: .delete,
            headers: headers,
            queryItems: queryItems
        )
        return try await request(endpoint, as: type)
    }

    private func buildRequest(from endpoint: Endpoint) throws -> URLRequest {
        guard let baseURL = configuration.baseURL else {
            throw NetworkError.missingBaseURL
        }

        let cleanPath = endpoint.path.hasPrefix("/") ? String(endpoint.path.dropFirst()) : endpoint.path
        let fullURL = baseURL.appendingPathComponent(cleanPath)

        guard var components = URLComponents(url: fullURL, resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidURL
        }

        if !endpoint.queryItems.isEmpty {
            components.queryItems = endpoint.queryItems
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url, timeoutInterval: configuration.timeout)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        let mergedHeaders = configuration.defaultHeaders.merging(endpoint.headers) { _, new in new }
        for (key, value) in mergedHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }

    private func perform(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw NetworkError.transportError(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode, data: data)
        }

        return (data, httpResponse)
    }
}
