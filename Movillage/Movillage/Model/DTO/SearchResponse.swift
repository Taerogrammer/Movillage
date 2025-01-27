import Foundation

struct SearchResponse: Decodable {
    let page: Int
    let results: [ResultsResponse]
    let total_pages: Int
    let total_results: Int
}
