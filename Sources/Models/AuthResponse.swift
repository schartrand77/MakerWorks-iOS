import Foundation

/// Response returned by auth-related endpoints containing token and user details
struct AuthResponse: Codable {
    let accessToken: String
    let email: String
    let username: String
    let groups: String?
    let user: User

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case email
        case username
        case groups
        case user
    }
}
