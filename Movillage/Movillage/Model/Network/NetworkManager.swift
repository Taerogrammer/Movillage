import UIKit
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    private init() { }

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
