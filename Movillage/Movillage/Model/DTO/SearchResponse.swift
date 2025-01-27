import Foundation

struct SearchResponse: Decodable {
    let page: Int
    let results: [ResultsResponse]
    let total_pages: Int
    let total_results: Int
}

struct SearchDTO {
    var query: String
    var page: Int
    
    func toRequest() -> TMDBRequest {
        return .search(query: query, page: page)
    }
}
