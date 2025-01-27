import Foundation

struct TrendingDTO: Decodable {
    let page: Int
    let results: [ResultsDTO]
}
