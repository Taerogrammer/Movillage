import Foundation

struct ResponseDTO: Decodable {
    let success: Bool
    let status_code: Int
    let status_message: String
}
