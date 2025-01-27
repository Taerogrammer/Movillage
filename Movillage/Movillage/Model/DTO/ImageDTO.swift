import Foundation

struct ImageDTO: Decodable {
    let id: Int
    let backdrops: [BackDropsDTO]
    let posters: [PostersDTO]
}

struct BackDropsDTO: Decodable {
    let file_path: String
}

struct PostersDTO: Decodable {
    let file_path: String
}
