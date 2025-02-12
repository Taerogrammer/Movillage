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
        let clickedIndexPath: Observable<IndexPath?> = Observable(nil)
        let sendDataToCollectionViewTapped: Observable<Void> = Observable(())
        let updateFavoriteMovie: Observable<Void> = Observable(())
    }
    struct Output {
        let trendingMovie: Observable<TrendingResponse> = Observable(TrendingResponse(page: 1, results: []))
        let totalMovieBox: Observable<Int> = Observable(0)
        let totalData: Observable<Int?> = Observable(nil)
        let profileImageName: Observable<String> = Observable("")
        let nicknamelabel: Observable<String> = Observable("")
        let numberOfItemsInZeroSection: Observable<Int> = Observable(1)
        let totalRecentSearch: Observable<Int> = Observable(0)

        let backdropArray: Observable<[String]?> = Observable(nil)
        let posterArray: Observable<[String]?> = Observable(nil)
        let footerData: Observable<FooterDTO> = Observable(FooterDTO(id: 0, title: "", overview: "", genre_ids: [], release_date: "", vote_average: 0.0))
        let synopsisData: Observable<String> = Observable("줄거리가 존재하지 않습니다.")
        let castData: Observable<[CastResponse]?> = Observable(nil)
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
        input.clickedIndexPath.lazyBind { [weak self] indexPath in
            guard let indexPath = indexPath else { return }
            self?.fetchBackdropAndPoster(indexPath: indexPath)
            self?.fetchFooter(indexPath: indexPath)
            self?.fetchSynopsis(indexPath: indexPath)
            self?.fetchCast(indexPath: indexPath)
        }
        input.sendDataToCollectionViewTapped.bind { [weak self] _ in
            self?.sendDataToCollectionView()
        }
        input.updateFavoriteMovie.lazyBind { [weak self] _ in
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
    private func fetchBackdropAndPoster(indexPath: IndexPath) {
        NetworkManager.shared.fetchItem(api: ImageDTO(movieID: output.trendingMovie.value.results[indexPath.row].id).toRequest(),
                                        type: ImageResponse.self) { [weak self] result in
            switch result {
            case .success(let success):
                self?.output.backdropArray.value = success.backdrops.prefix(5).map {
                    TMDBUrl.imageUrl + $0.file_path
                }
                self?.output.posterArray.value = success.posters.map { TMDBUrl.imageUrl + $0.file_path }
            case .failure(let failure):
                /// self.networkErrorAlert(error: failure)
                print("error ", failure)
            }
        }
    }
    private func fetchFooter(indexPath: IndexPath) {
        let data = output.trendingMovie.value.results[indexPath.row]
        output.footerData.value = FooterDTO(id: data.id, title: data.title, overview: data.overview, genre_ids: data.genre_ids, release_date: data.release_date, vote_average: data.vote_average)
    }
    private func fetchSynopsis(indexPath: IndexPath) {
        output.synopsisData.value = output.trendingMovie.value.results[indexPath.row].overview
    }
    private func fetchCast(indexPath: IndexPath) {
        NetworkManager.shared.fetchItem(api: CreditDTO(movieID: output.trendingMovie.value.results[indexPath.row].id).toRequest(),
                                        type: CreditResponse.self) { [weak self] result in
            switch result {
            case .success(let success):
                if success.cast.count > 0 {
                    self?.output.castData.value = success.cast
                }
            case .failure(let failure):
                /// self.networkErrorAlert(error: failure)
                print("error ", failure)
            }
        }
    }
}
