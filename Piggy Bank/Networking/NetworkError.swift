import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int, data: Data?)
    case decodingError(Error)
    case encodingError(Error)
    case transportError(Error)
    case missingBaseURL

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid server response."
        case .serverError(let statusCode, _):
            return "Server responded with status code \(statusCode)."
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Failed to encode request body: \(error.localizedDescription)"
        case .transportError(let error):
            return "Network transport error: \(error.localizedDescription)"
        case .missingBaseURL:
            return "Base URL is missing."
        }
    }
}
