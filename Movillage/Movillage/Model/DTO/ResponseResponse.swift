import Foundation

struct ResponseResponse: Decodable {
    let success: Bool
    let status_code: Int
    let status_message: String
}
