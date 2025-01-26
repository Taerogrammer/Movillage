import Foundation

struct CreditDTO {
    let id: Int
    let cast: [CastDTO]
}

struct CastDTO {
    let name: String
    let character: String
    let profile_path: String
}
