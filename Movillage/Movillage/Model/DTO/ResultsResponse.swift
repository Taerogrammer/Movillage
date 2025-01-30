import Foundation

struct ResultsResponse: Decodable {
    let id: Int
    let backdrop_path: String?
    let title: String
    let overview: String
    let poster_path: String
    let genre_ids: [Int]
    let release_date: String
    let vote_average: Double
}

struct FooterDTO {
    let overview: String
    let genre_ids: [Int]
    let release_date: String
    let vote_average: Double
}
