import Foundation

enum NetworkError: Int, Error {
    case invalidInput = 400
    case invalidAuth = 401
    case duplicateOrSuspended = 403
    case notFound = 404
    case methodNotAllowed = 405
    case invalidHeader = 406
    case invalidParameters = 422
    case tooManyRequests = 429
    case internalServerError = 500
    case backendError = 502
    case serviceOffline = 503
    case serverTimeout = 504

    var errorMessage: String {
        switch self {
        case .invalidInput:
            return "유효하지 않은 값입니다."
        case .invalidAuth:
            return "사용자 인증에 실패하였습니다."
        case .duplicateOrSuspended:
            return "중복된 데이터이거나 계정이 정지되었습니다."
        case .notFound:
            return "요청한 리소스를 찾을 수 없습니다."
        case .methodNotAllowed:
            return "지원되지 않는 요청 방식입니다."
        case .invalidHeader:
            return "유효하지 않은 헤더입니다."
        case .invalidParameters:
            return "요청한 매개변수가 올바르지 않습니다."
        case .tooManyRequests:
            return "요청 횟수를 초과하였습니다. 잠시 후 다시 시도해주세요."
        case .internalServerError:
            return "서버 내부 오류가 발생하였습니다. 관리자에게 문의해주세요."
        case .backendError:
            return "백엔드 서버와의 연결에 실패하였습니다. 관리자에게 문의해주세요."
        case .serviceOffline:
            return "현재 서비스 점검 중입니다. 나중에 다시 시도해주세요."
        case .serverTimeout:
            return "서버 요청 시간이 초과되었습니다. 다시 시도해주세요."
        }
    }
}
