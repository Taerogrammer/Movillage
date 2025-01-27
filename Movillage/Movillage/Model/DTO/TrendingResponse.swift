import Foundation

struct TrendingResponse: Decodable {
    let page: Int
    let results: [ResultsResponse]
}
