import Foundation

final class CinemaViewModel: BaseViewModel {
    private(set) var input: Input
    private(set) var output: Output
    let cinemaSection = ["최근검색어", "오늘의 영화"]

    struct Input {
        let viewDidLoad: Observable<Void> = Observable(())
        let viewWillAppear: Observable<Void> = Observable(())
        let updateProfile: Observable<Void> = Observable(())
        let numberOfItemsInSection: Observable<Void> = Observable(())
        let cellForItemAt: Observable<Void> = Observable(())
    }
    struct Output {
        let trendingMovie: Observable<TrendingResponse> = Observable(TrendingResponse(page: 1, results: []))
        let totalMovieBox: Observable<Int> = Observable(0)
        let totalData: Observable<Int?> = Observable(nil)
        let profileImageName: Observable<String> = Observable("")
        let nicknamelabel: Observable<String> = Observable("")
        let numberOfItemsInZeroSection: Observable<Int> = Observable(1)
        let totalRecentSearch: Observable<Int> = Observable(0)
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
        input.updateProfile.bind { [weak self] _ in
            self?.updatedProfileReceived()
        }
        input.numberOfItemsInSection.bind { [weak self] _ in
            self?.countRecentSearchForSection()
        }
        input.cellForItemAt.bind { [weak self] _ in
            self?.countRecentSearch()
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
        output.totalData.value = getDataCount(data: UserDefaultsManager.recentSearch)
    }
    private func isDataExists(data: Int) -> Bool { return data > 0 }
    private func getDataCount(data: [String]) -> Int { return data.count }
    private func getFavoriteMovieCount() {
        output.totalMovieBox.value = UserDefaultsManager.favoriteMovie.count
    }
    private func updatedProfileReceived() {
        output.profileImageName.value = UserDefaultsManager.profileImage ?? "profile_0"
        output.nicknamelabel.value = UserDefaultsManager.nickname ?? ""
    }
    private func countRecentSearch() {
        output.totalRecentSearch.value = UserDefaultsManager.recentSearch.count
    }
    private func countRecentSearchForSection() {
        output.numberOfItemsInZeroSection.value = max(UserDefaultsManager.recentSearch.count, 1)
    }
}
