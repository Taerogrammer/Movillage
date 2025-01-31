import Foundation

struct CreditResponse: Decodable {
    let id: Int
    let cast: [CastResponse]
}

struct CastResponse: Decodable {
    let name: String
    let character: String
    let profile_path: String?
    var imageUrl: String { "https://image.tmdb.org/t/p/original" + (profile_path ?? "") }
}

struct CreditDTO {
    var movieID: Int

    func toRequest() -> TMDBRequest {
        return .credit(movieID: movieID)
    }
}
