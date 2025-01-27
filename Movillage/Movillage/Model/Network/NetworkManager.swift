import UIKit
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    private init() { }

    let header: HTTPHeaders = ["Authorization" : "Bearer \(APIKey.TMDB.rawValue)"]

    func fetchTrending(completionHandler: @escaping (Result<TrendingDTO, Error>) -> Void) {
        print(#function)
        let url = URL(string: "https://api.themoviedb.org/3/trending/movie/day?language=ko-KR&page=1")!
        AF.request(url, method: .get, headers: header)
            .responseDecodable(of: TrendingDTO.self) { response in
                completionHandler(response.result.mapError { $0 as Error })
            }
    }
    func fetchSearch(query: String, completionHandler: @escaping (Result<SearchDTO, Error>) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?query=\(query)&include_adult=false&language=ko-KR&page=1")!
        AF.request(url, method: .get, headers: header)
            .responseDecodable(of: SearchDTO.self) { response in
                completionHandler(response.result.mapError { $0 as Error })
            }
    }
    func fetchImage(movieID: String, completionHandler: @escaping (Result<ImageDTO, Error>) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/images")!
        AF.request(url, method: .get, headers: header)
            .responseDecodable(of: ImageDTO.self) { response in
                completionHandler(response.result.mapError { $0 as Error })
            }
    }
    func fetchCredit(movieID: String, completionHandler: @escaping (Result<CreditDTO, Error>) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/credits?language=ko-KR")!
        AF.request(url, method: .get, headers: header)
            .responseDecodable(of: CreditDTO.self) { response in
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


 */
