import Foundation

final class CinemaViewModel: BaseViewModel {
    private(set) var input: Input
    private(set) var output: Output

    struct Input {
        let viewDidLoad: Observable<Void> = Observable(())
    }
    struct Output {
        let trendingMovie: Observable<TrendingResponse> = Observable(TrendingResponse(page: 1, results: []))
    }

    init() {
        input = Input()
        output = Output()

        transform()
    }
    func transform() {
        input.viewDidLoad.lazyBind { [weak self] _ in
            self?.fetchTrending()
        }
    }
    private func fetchTrending() {
        NetworkManager.shared.fetchItem(api: TrendingDTO().toRequest(),
                                        type: TrendingResponse.self) { [weak self] result in
            switch result {
            case .success(let success):
                self?.output.trendingMovie.value = success
            case .failure(let failure):
                ///self.networkErrorAlert(error: failure)
                print("error -> ", failure)
            }
        }
    }

}
