import Foundation

struct FavoriteResponse: Decodable {
    let results: [ResultsResponse]
}

struct FavoriteDTO {
    
    func toRequest() -> TMDBRequest {
        return .getFavorite
    }
}
