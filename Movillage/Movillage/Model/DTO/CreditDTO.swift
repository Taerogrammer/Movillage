import Foundation

struct CreditDTO: Decodable {
    let id: Int
    let cast: [CastDTO]
}

struct CastDTO: Decodable {
    let name: String
    let character: String
    let profile_path: String?
}
