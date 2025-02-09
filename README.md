# Movillage

### 영화 덕후라면? 아직도 검색하며 헤매고 있다면? 이제 Movillage에서 한방에 해결하세요!

Movillage는 최신 개봉작부터 인기 영화, 숨은 명작까지 **다양한 영화 정보를 한곳에서 빠르고 쉽게 검색하고 관리**할 수 있는 iOS 앱입니다.

<br>
<br>
<br>

# UI



<br>
<br>
<br>

# 주요 기능

### ✅ 최신 트렌드 영화 제공

매일 업데이트되는 인기 영화 목록을 확인하고, 현재 화제가 되고 있는 작품들을 빠르게 찾아볼 수 있습니다.

<br>

### ✅ 강력한 검색 기능 

제목만 입력하면 영화의 상세 정보를 한눈에 확인할 수 있습니다. 원하는 영화를 쉽고 빠르게 검색해보세요.

<br>

### ✅ 출연 배우, 감독, 줄거리, 예고편까지 한눈에!

각 영화의 주요 정보, 출연 배우, 감독 뿐만 아니라 상세 줄거리뿐까지 한 화면에서 확인할 수 있습니다.

<br>

### ✅ 최근 검색어 저장

검색한 영화는 자동으로 저장되며, 언제든지 쉽게 다시 확인할 수 있습니다. 자주 찾는 영화 정보를 놓치지 마세요!

<br>

### ✅ 좋아요(즐겨찾기) 기능

마음에 드는 영화는 ‘좋아요’ 버튼을 눌러 보관할 수 있으며, 저장한 영화 목록은 언제든지 다시 볼 수 있습니다.

<br>

### ✅ 깔끔한 UI

부드럽고 직관적인 UI를 제공하며, 세련된 디자인을 유지합니다.

<br>
<br>
<br>

# 개발 기간 및 팀 구성

- 개발 기간 : 2025.01.26 ~ 2025.02.01 (7일)
- 개발 인원 : 1명

<br>
<br>
<br>

# 기술 스택

- 언어 : Swift
- UI 프레임워크 : UIKit Code base
- 디자인 패턴 : MVC 패턴
- 데이터베이스 : UserDefaults
- 라이브러리 및 프레임워크 : Alamofire  /  Kingfisher  /  Snapkit

<br>
<br>
<br>

# 기술 설명

## 아키텍쳐 - MVC 패턴
MVC 패턴을 기반으로 개발을 진행하였습니다. 빠른 개발 속도가 필요했고, 규모가 작은 프로젝트였기 때문에 MVC 패턴을 도입하였습니다.

```
.
├── Assets.xcassets
├── Base
├── Base.lproj
├── Components
│   ├── ButtonComponent
│   ├── ImageComponent
│   └── LabelComponent
├── Controllers
│   ├── Cinema
│   ├── CinemaDetail
│   ├── Onboarding
│   ├── Profile
│   ├── Search
│   ├── Setting
│   ├── TabBar
│   └── Upcoming
├── Extension
├── Model
│   ├── DTO
│   ├── Network
│   ├── RouterSetting
│   └── UserDefaults
├── Protocol
└── Views
    ├── Cinema
    ├── CinemaDetail
    ├── Onboarding
    ├── Profile
    ├── Search
    ├── Setting
    └── Upcoming
```

View / Model / Controller를 기반으로 폴더링을 하였습니다.

<br>

## 데이터베이스 - UserDefaults

유저의 닉네임, 프로필 사진, 좋아요 리스트 등을 저장하기 위해 iOS의 로컬 DB인 UserDefualts를 사용하였습니다. UserDefaults는 키-값 쌍으로 이루어져있는 경량화된 DB로, 다음과 같은 장점이 있습니다.

- 별다른 설정 없이 간단하게 로컬 DB를 정의하고 사용할 수 있습니다.
- 사용 방법이 간단하기 때문에 러닝 커브가 매우 낮아 빠르게 적용할 수 있습니다.


<br>

## 네트워크 - Alamofire

네트워크 통신을 위해 Alamofire 라이브러리를 사용하였습니다.

Alamofire는 HTTP 네트워크 통신을 위한 라이브러리로, URLSession을 기반으로 구현되었으며, 비동기적으로 동작합니다. 다음과 같은 장점이 있어 사용하였습니다.

- request, response 등의 메서드를 dot syntax 등을 통해 간편하게 호출할 수 있습니다.
- ULRSession을 기반으로 만들어졌기 때문에 커스텀을 기반으로 한 다른 라이브러리보다 안정성이 뛰어납니다.
- 객체로 정의하여 반복적인 보일러플레이트 코드를 감소시킬 수 있습니다.

```
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
        .cURLDescription { print($0) }
        .validate(statusCode: 200..<299)
        .responseDecodable(of: T.self) { response in
            completionHandler(response.result.mapError { error in
                let statusCode = response.response?.statusCode ?? 500
                return NetworkError(rawValue: statusCode) ?? .internalServerError
            })
        }
    }
}
```

<br>

## 오토 레이아웃 - SnapKit

여러 디바이스에 대응하기 위해 오토 레이아웃을 기반으로 UI를 구현하였고, SnapKit 라이브러리를 기반으로 구현하였습니다.

SnapKit 라이브러리는 오토 레이아웃을 간단하게 구현할 수 있도록 도와주는 라이브러리로, 다음과 같은 장점이 있습니다.
-  ```translatesAutoresizingMaskIntoConstraints```를 기본값으로 지원해줍니다.
-  동일한 constraints를 한 번에 표현할 수 있어, 코드가 간결해집니다.

```
backdropImage.snp.makeConstraints {
    $0.edges.equalTo(safeAreaLayoutGuide)
}
```

<Br>

## 이미지 호출 - Kingfisher

TMDB API를 통해 호출된 이미지 데이터를 렌더링하기 위해 사용한 라이브러리로, 다음과 같은 장점이 있어 사용하였습니다.

- 비동기적으로 이미지를 다운받고, 캐싱을 지원합니다.
- ULRSession을 기반으로 만들어졌기 때문에 커스텀을 기반으로 한 다른 라이브러리보다 안정성이 뛰어납니다.
- **디스크 캐싱과 메모리 캐싱 기능 등을 제공함으로써 이미지 로딩 시간을 줄여줍니다.**
- DownSampling 등의 유용한 이미지 프로세서 기능을 제공합니다.


<br>
<br>
<br>

# 화면 별 구현 사항

## UserDefaults

### PropertyWrapper를 사용하여 보일러플레이트 코드를 감소시켰습니다.

```
@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    let storage: UserDefaults

    var wrappedValue: T {
        get { self.storage.object(forKey: self.key) as? T ?? self.defaultValue }
        set { self.storage.set(newValue, forKey: self.key) }
    }

    func removeObject() { storage.removeObject(forKey: key) }
}

final class UserDefaultsManager {
    enum Key: String {
        case isStart, profileImage, nickname, registerDate, recentSearch, favoriteMovie
    }

    @UserDefault(key: Key.isStart.rawValue, defaultValue: false, storage: .standard)
    static var didStart: Bool
    @UserDefault(key: Key.profileImage.rawValue, defaultValue: nil, storage: .standard)
    static var profileImage: String?
    @UserDefault(key: Key.nickname.rawValue, defaultValue: nil, storage: .standard)
    static var nickname: String?
    @UserDefault(key: Key.registerDate.rawValue, defaultValue: nil, storage: .standard)
    static var registerDate: String?
    @UserDefault(key: Key.recentSearch.rawValue, defaultValue: [], storage: .standard)
    static var recentSearch: [String]
    @UserDefault(key: Key.favoriteMovie.rawValue, defaultValue: [], storage: .standard)
    static var favoriteMovie: [Int]
}

```

- ```UserDefaults```는 get-set으로 구성할 수 있는데, 여러 데이터를 관리할 때에 ```get-set```의 반복으로 보일러플레이트 코드가 발생하기 때문에 ```@PropertyWrapper``` 기능을 사용하였습니다.
 
- ```@PropertyWrapper```를 통해 프로퍼티를 실행하는 구문과 행위에 대한 정의를 분리하여 코드의 재사용성을 높였습니다.

<br>

## NetworkManager

### 싱글턴 패턴으로 구현하였습니다.
```
import UIKit
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    ...
}
```
- NetworkManager를 타입 프로퍼티로 선언한 후, private init()으로 선언하여 외부에서 인스턴스를 새로 생성하지 못하도록 함으로써 싱글턴 패턴으로 구현하였습니다.

<br>

다음과 같은 장점으로 인해 싱글턴 패턴을 적용하였습니다.
- 어디서든 동일한 인스턴스에 접근하여 불필요한 객체 생성을 방지합니다.
- 네트워크 요청을 한 곳에서 관리할 수 있습니다.

<br>

### 제네릭 타입을 사용하여 코드의 재사용성을 증가시켰습니다.
```
func fetchItem<T: Decodable>(api: TMDBRequest,
                                type: T.Type,
                                completionHandler: @escaping (Result<T, Error>) -> Void) {
    AF.request(
        api.endPoint,
        method: api.method,
        parameters: api.parameter,
        encoding: api.encoding,
        headers: api.header)
    .cURLDescription { print($0) }
    .validate(statusCode: 200..<299)
    .responseDecodable(of: T.self) { response in
        completionHandler(response.result.mapError { error in
            let statusCode = response.response?.statusCode ?? 500
            return NetworkError(rawValue: statusCode) ?? .internalServerError
        })
    }
}
```

- 제네릭을 활용함으로써, **Decodable**을 준수하는 모든 데이터 타입에 대응할 수 있습니다.
- 각 데이터 타입마다 별도로 네트워크 요청을 작성할 필요가 없으며 코드 중복을 최소화할 수 있습니다.

<br>

### Requset에 대한 케이스를 ```enum```으로 정리하여 하나의 모델로 관리하였습니다.

```
enum TMDBRequest {
    case trending
    case search(query: String, page: Int)
    case image(movieID: Int)
    case credit(movieID: Int)
    case getFavorite
    case postFavorite(media_id: Int, favorite: Bool)

    var header: HTTPHeaders { return ["Authorization" : "Bearer \(APIKey.TMDB.rawValue)"] }
    var endPoint: URL {
        switch self {
        case .trending:
            return URL(string: TMDBUrl.baseUrl + "/trending/movie/day")!
        case .search(_, _):
            return URL(string: TMDBUrl.baseUrl + "/search/movie")!
        case .image(let movieID):
            return URL(string: TMDBUrl.baseUrl + "/movie/\(movieID)/images")!
        case .credit(let movieID):
            return URL(string: TMDBUrl.baseUrl + "/movie/\(movieID)/credits")!
        case .getFavorite:
            return URL(string: TMDBUrl.baseUrl + "/account/\(APIKey.TMDB.rawValue)/favorite/movies")!
        case .postFavorite:
            return URL(string: TMDBUrl.baseUrl + "/account/\(APIKey.TMDB.rawValue)/favorite")!
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

```

- 네트워크 요청 코드의 가독성과 재사용성을 향상시켰습니다.
- 새로운 API를 간편하게 추가할 수 있습니다.

<br>

### ```final```, ```private```, ```AnyObject``` 키워드를 통해 성능 개선을 기대하였습니다.

```
final class OnboardingViewController: UIViewController {
    private let onboardingView = OnboardingView()
    ...
}


protocol ViewConfiguration: AnyObject {
    func configureHierarchy()
    func configureLayout()
    func configureView()
}
```

- ```final``` 키워드는 direct call 방식으로 구현되어 컴파일 타임에 실제 호출이 결정되기 때문에 링킹 과정에서 성능적인 개선을 기대할 수 있습니다.
- ```private``` 키워드 또한 접근 제어를 통해 컴파일러가 잠재적인 오버라이드에 대한 확인을 하지 않도록 합니다.
- ```AnyObject``` 키워드는 해당 프로토콜이 클래스에서만 채택할 수 있도록 정의하여 값 타입인지, 참조 타입인지(참조를 retain/release 해야할지) 계속해서 고려하지 않도록 도와줍니다.



<br>
<br>
<br>

# 트러블 슈팅

## 여러 이미지 데이터를 불러올 때에 메모리 이슈가 발생하였습니다.

영화와 관련된 포스터, 백드롭 등 매우 많은 이미지가 존재하기 때문에,이미지 렌더링 시 메모리 사용량이 많아지는 문제가 발생했습니다. 이를 해결하기 위해 다음과 같은 방법들을 사용하였습니다.

<br>

### DownSampling을 통하여 이미지 크기를 줄였습니다.
```
func configureImageCell(with urlString: String?) {
    guard let urlString = urlString else { return }
    guard let url = URL(string: urlString) else { return }
    backdropImage.kf.indicatorType = .activity
    backdropImage.kf.setImage(with: url, options: [
        .processor(DownsamplingImageProcessor(size: self.backdropImage.bounds.size)),
        .scaleFactor(UIScreen.main.scale)
    ])
}
```
이미지는 기본적으로 **data -> image -> rendering** 과정을 거쳐 렌더링됩니다. DownSampling은 data에서 image로 변환되는 과정에서 원본 이미지의 크기를 줄여 메모리를 최적화하는 기법입니다. 

포스터와 같은 이미지들은 고화질의 이미지보단 빠른 렌더링이 더욱 중요하다고 생각하여 Kingfisher의 DownSampling을 적용하여 메모리를 관리하고자 하였습니다.

<br>

### 디스크 캐시의 기간을 설정하여 불필요한 디스크 캐싱을 방지하고자 하였습니다.

```
/// 오늘의 영화는 하루 단위를 기준으로 업데이트 되기 때문에 하루 동안만 캐시에 저장되도록 지정
self.posterImage.kf.setImage(with: url, options: [
    .processor(DownsamplingImageProcessor(size: self.posterImage.bounds.size)),
    .scaleFactor(UIScreen.main.scale),
    .cacheOriginalImage,
    .memoryCacheExpiration(.days(1)),
    .diskCacheExpiration(.days(1))
    ])
```
Kingfisher는 이미지 프로세서를 사용한 경우, 이미지 프로세서가 적용된 최종 결과와 원본 이미지 둘 다를 캐싱하는데, 원본 이미지는 디스크 스토리지에 저장합니다. 
원본 이미지의 기본 저장 기간은 7일입니다.
하지만 '오늘의 영화'는 하루마다 영화의 정보가 변경되기 때문에 7일 동안 저장하는 것은 디스크 스토리지를 비효율적으로 사용하는 문제를 초래합니다.

<br>

따라서, '오늘의 영화'에 해당하는 이미지는 캐싱 기간을 하루로 제한하여 디스크 스토리지를 관리하였습니다.

<br>
<br>
<br>

# 프로젝트 회고

## 시도한 점 (Try)


<br>

## 배운 점 (Learned)

<br>

## 아쉬운 점 (Lacked)

<br>

## 향후 계획 (To do)