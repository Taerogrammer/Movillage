import Foundation

struct ImageDTO {
    let id: Int
    let backdrops: [BackDropsDTO]
    let posters: [PostersDTO]
}

struct BackDropsDTO {
    let file_path: String
}

struct PostersDTO {
    let file_path: String
}
