import Foundation
import Alamofire

enum TMDBRequest {
    case trending
    case search(query: String, page: Int)
    case image(movieID: Int)
    case credit(movieID: Int)
    case getFavorite
    case postFavorite(media_id: Int, favorite: Bool)

    var baseUrl: String { return "https://api.themoviedb.org/3" }
    var header: HTTPHeaders { return ["Authorization" : "Bearer \(APIKey.TMDB.rawValue)"] }
    var endPoint: URL {
        switch self {
        case .trending:
            return URL(string: baseUrl + "/trending/movie/day")!
        case .search(_, _):
            return URL(string: baseUrl + "/search/movie")!
        case .image(let movieID):
            return URL(string: baseUrl + "/movie/\(movieID)/images")!
        case .credit(let movieID):
            return URL(string: baseUrl + "/movie/\(movieID)/credits")!
        case .getFavorite:
            return URL(string: baseUrl + "/account/\(APIKey.TMDB.rawValue)/favorite/movies")!
        case .postFavorite:
            return URL(string: baseUrl + "/account/\(APIKey.TMDB.rawValue)/favorite")!
        }
    }
    var parameter: Parameters {
        switch self {
        case .trending:
            return ["language": "ko-KR", "page": 1]
        case .search(let query, let page):
            return ["query": query, "include_adult": "false", "language": "ko-KR", "page": page]
        case .image(_):
            return [:]
        case .credit(_):
            return ["language": "ko-KR"]
        case .getFavorite:
            return ["language":"ko-KR"]
        case .postFavorite(let media_id, let favorite):
            return ["media_type": "movie", "media_id": media_id, "favorite": favorite]
        }
    }
    var method: HTTPMethod {
        switch self {
        case .trending:
            return .get
        case .search(_, _):
            return .get
        case .image(_):
            return .get
        case .credit(_):
            return .get
        case .getFavorite:
            return .get
        case .postFavorite(_, _):
            return .post
        }
    }
    var encoding: URLEncoding {
        switch self {
        case .trending:
            URLEncoding(destination: .queryString)
        case .search(_, _):
            URLEncoding(destination: .queryString)
        case .image(_):
            URLEncoding(destination: .queryString)
        case .credit(_):
            URLEncoding(destination: .queryString)
        case .getFavorite:
            URLEncoding(destination: .queryString)
        case .postFavorite(_, _):
            URLEncoding(destination: .httpBody)
        }
    }
}
