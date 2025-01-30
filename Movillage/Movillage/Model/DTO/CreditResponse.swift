import Foundation

struct CreditResponse: Decodable {
    let id: Int
    let cast: [CastResponse]
}

struct CastResponse: Decodable {
    let name: String
    let character: String
    let profile_path: String?
}

struct CreditDTO {
    var movieID: Int

    func toRequest() -> TMDBRequest {
        return .credit(movieID: movieID)
    }
}
