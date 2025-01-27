import Foundation

struct ImageResponse: Decodable {
    let id: Int
    let backdrops: [BackDropsResponse]
    let posters: [PostersResponse]
}

struct BackDropsResponse: Decodable {
    let file_path: String
}

struct PostersResponse: Decodable {
    let file_path: String
}

struct ImageDTO {
    var movieID: Int

    func toRequest() -> TMDBRequest {
        return .image(movieID: movieID)
    }
}
