import Foundation

struct SearchDTO {
    let page: Int
    let results: [ResultsDTO]
    let total_pages: Int
    let total_results: Int
}
