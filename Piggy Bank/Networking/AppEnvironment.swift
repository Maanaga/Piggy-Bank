import Foundation

enum AppEnvironment {
    static var baseURLString: String = "https://translucent-fisher-micrographically.ngrok-free.dev"

    static var networkService: NetworkService = {
        NetworkService(
            configuration: NetworkConfiguration(
                baseURL: URL(string: baseURLString),
                defaultHeaders: [
                    "Content-Type": "application/json",
                    "Accept": "application/json",
                    "ngrok-skip-browser-warning": "true"
                ]
            )
        )
    }()

    static func updateBaseURL(_ newBaseURLString: String) {
        baseURLString = newBaseURLString
        networkService.updateBaseURL(URL(string: newBaseURLString))
    }
}
