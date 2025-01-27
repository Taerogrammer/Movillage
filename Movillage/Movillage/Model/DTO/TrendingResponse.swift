import Foundation

struct TrendingResponse: Decodable {
    let page: Int
    let results: [ResultsResponse]
}

struct TrendingDTO {
    func toRequest() -> TMDBRequest {
        return .trending
    }
}
