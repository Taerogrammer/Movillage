import Foundation

final class CinemaDetailViewModel: BaseViewModel {
    private(set) var input: Input
    private(set) var output: Output
    private(set) var detailSection = ["", "Synopsis", "Cast", "Poster"]

    struct Input {

    }
    struct Output {

    }
    init() {
        input = Input()
        output = Output()

        transform()
    }
    func transform() {

    }
}
