import UIKit
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    private init() { }

    let header: HTTPHeaders = ["Authorization" : "Bearer \(APIKey.TMDB.rawValue)"]

    func fetchTrending(completionHandler: @escaping (Result<TrendingResponse, Error>) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/trending/movie/day?language=ko-KR&page=1")!
        AF.request(url, method: .get, headers: header)
            .responseDecodable(of: TrendingResponse.self) { response in
                completionHandler(response.result.mapError { $0 as Error })
            }
    }
    func fetchSearch(query: String, page: Int, completionHandler: @escaping (Result<SearchResponse, Error>) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?query=\(query)&include_adult=false&language=ko-KR&page=\(page)")!
        AF.request(url, method: .get, headers: header)
            .responseDecodable(of: SearchResponse.self) { response in
                completionHandler(response.result.mapError { $0 as Error })
            }
    }
    func fetchImage(movieID: String, completionHandler: @escaping (Result<ImageResponse, Error>) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/images")!
        AF.request(url, method: .get, headers: header)
            .responseDecodable(of: ImageResponse.self) { response in
                completionHandler(response.result.mapError { $0 as Error })
            }
    }
    func fetchCredit(movieID: String, completionHandler: @escaping (Result<CreditResponse, Error>) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/credits?language=ko-KR")!
        AF.request(url, method: .get, headers: header)
            .responseDecodable(of: CreditResponse.self) { response in
                completionHandler(response.result.mapError { $0 as Error })
            }
    }
    func fetchFavorite(completionHandler: @escaping (Result<FavoriteResponse, Error>) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/account/\(APIKey.TMDB.rawValue)/favorite/movies")!
        AF.request(url, method: .get, headers: header)
            .responseDecodable(of: FavoriteResponse.self) { response in
                completionHandler(response.result.mapError { $0 as Error })
            }
    }

    let parameter: [String: Any] = [
        "media_type": "movie",
        "media_id": 550,
        "favorite": true
    ]

    func postFavorite(media_id: Int, favorite: Bool, completionHandler: @escaping (Result<ResponseResponse, Error>) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/account/\(APIKey.TMDB.rawValue)/favorite")!
        AF.request(url,
                   method: .post,
                   parameters: parameter,
                   encoding: URLEncoding(destination: .httpBody),
                   headers: header)
        .responseDecodable(of: ResponseResponse.self) { response in
            switch response.result {
            case .success(let success):
                print("성공 ---> ", success)
                completionHandler(.success(success))
            case .failure(let failure):
                print("실패 --> ", failure)
                completionHandler(.failure(failure))
            }
        }
    }




    func fetchItem<T: Decodable>(api: TMDBRequest,
                                 type: T.Type,
                                 completionHandler: @escaping (Result<T, Error>) -> Void) {
        AF.request(
            api.endPoint,
            method: api.method,
            parameters: api.parameter,
            encoding: api.encoding,
            headers: api.header)
//        .cURLDescription { print($0) }
        .responseDecodable(of: T.self) { response in
            completionHandler(response.result.mapError { $0 as Error })
        }
    }
}
/*
fetchTrending
 NetworkManager.shared.fetchTrending { result in
     switch result {
     case .success(let success):
         print("Success ->", success)
     case .failure(let failure):
         print("Error -> ", failure)
     }
 }


 fetchSearch
 NetworkManager.shared.fetchSearch(query: "해리") { result in
     switch result {
     case .success(let success):
         print("성공 ", success)
     case .failure(let failure):
         print("실패 ", failure)
     }


 fetchImage
 NetworkManager.shared.fetchImage(movieID: "939243") { result in
     switch result {
     case .success(let success):
         print("성공", success)
     case .failure(let failure):
         print(failure)
     }
 }
 }


 fetchCredit
 NetworkManager.shared.fetchCredit(movieID: "939243") { result in
     switch result {
     case .success(let success):
         print(success)
     case .failure(let failure):
         print(failure)
     }
 }


 postFavorite
 NetworkManager.shared.postFavorite { result in
     switch result {
     case .success(let success):
         print("success -> ", success)
     case .failure(let failure):
         print(failure)
     }
 }

 */
