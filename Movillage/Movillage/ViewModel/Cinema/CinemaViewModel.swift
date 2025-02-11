import Foundation

final class CinemaViewModel: BaseViewModel {
    private(set) var input: Input
    private(set) var output: Output

    struct Input {
        let viewDidLoad: Observable<Void> = Observable(())
        let viewWillAppear: Observable<Void> = Observable(())
    }
    struct Output {
        let trendingMovie: Observable<TrendingResponse> = Observable(TrendingResponse(page: 1, results: []))
        let totalMovieBox: Observable<Int> = Observable(0)
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
        input.viewWillAppear.lazyBind { [weak self] _ in
            self?.sendDataToCollectionView()
            self?.getFavoriteMovieCount()
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
    // 최근검색어 여부 전달
    private func sendDataToCollectionView() {
        print(#function)
    }
    private func isDataExists(data: Int) -> Bool { return data > 0 }
    private func getDataCount(data: [String]) -> Int { return data.count }
    private func getFavoriteMovieCount() {
        output.totalMovieBox.value = UserDefaultsManager.favoriteMovie.count
    }

}
