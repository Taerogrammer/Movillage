import Foundation

final class SearchViewModel: BaseViewModel {
    private(set) var input: Input
    private(set) var output: Output

    struct Input {
        let viewWillAppear: Observable<Void> = Observable(())
        let searchText: Observable<String> = Observable("")
        let searchDTO: Observable<SearchDTO> = Observable(SearchDTO(query: "", page: 1))
        let loadMoreDataTrigger: Observable<Void> = Observable(())
        let clickedIndexPath: Observable<IndexPath?> = Observable(nil)
        let clickedId: Observable<Int> = Observable(0)
    }
    struct Output {
        let searchResponse: Observable<SearchResponse> = Observable(SearchResponse(page: 1, results: [ResultsResponse](), total_pages: 1, total_results: 1))
        let searchData: Observable<[ResultsResponse]> = Observable([])
        let notFoundLabelVisible: Observable<Bool> = Observable(false)
        let indexPath: Observable<IndexPath> = Observable(IndexPath())
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
        input.clickedIndexPath.lazyBind { [weak self] indexPath in
            guard let indexPath = indexPath else { return }
            self?.fetchBackdropAndPoster(indexPath: indexPath)
            self?.fetchFooter(indexPath: indexPath)
            self?.fetchSynopsis(indexPath: indexPath)
            self?.fetchCast(indexPath: indexPath)
            self?.output.indexPath.value = indexPath
        }
        input.viewWillAppear.bind { [weak self] _ in
            self?.updateClickedIndexPath()
        }
        input.searchText.lazyBind { [weak self] query in
            self?.configureUserDefaultsRecentSearch(text: query)
            self?.resetPage()
            self?.input.searchDTO.value.query = query
            self?.fetchSearchData()
        }
        input.loadMoreDataTrigger.lazyBind { [weak self] _ in
            self?.loadMoreData()
        }
        input.clickedId.lazyBind { [weak self] movieID in
            self?.toggleFavoriteMovie(with: movieID)
        }
    }
    private func resetPage() { input.searchDTO.value.page = 1 }
    private func configureUserDefaultsRecentSearch(text: String) {
        UserDefaultsManager.recentSearch.removeAll { $0 == text }   // 중복 제거
        UserDefaultsManager.recentSearch.insert(text, at: 0)
    }
    private func fetchSearchData() {
        NetworkManager.shared.fetchItem(api: input.searchDTO.value.toRequest(),
                                        type: SearchResponse.self) { [weak self] result in
            switch result {
            case .success(let success):
                self?.output.searchResponse.value = success
                self?.output.searchData.value = success.results
                self?.notFoundLabelVisibility()
            case .failure(let failure):
                /// self.networkErrorAlert(error: failure)
                print("error -> ", failure)
            }
        }
    }
    private func notFoundLabelVisibility() {
        output.notFoundLabelVisible.value = (output.searchResponse.value.results.count == 0) ? true : false
    }
    private func loadMoreData() {
        input.searchDTO.value.page += 1
        NetworkManager.shared.fetchItem(api: input.searchDTO.value.toRequest(),
                                        type: SearchResponse.self) { [weak self] result in
            switch result {
            case .success(let success):
                self?.output.searchData.value.append(contentsOf: success.results)
            case .failure(let failure):
                /// self.networkErrorAlert(error: failure)
                print("error ", failure)
            }
        }
    }
    private func updateClickedIndexPath() {
        guard let indexPath = input.clickedIndexPath.value else { return }
        output.indexPath.value = indexPath
    }
    private func toggleFavoriteMovie(with movieID: Int) {
        if UserDefaultsManager.favoriteMovie.contains(movieID) {
            UserDefaultsManager.favoriteMovie.removeAll(where: { $0 == movieID })
        } else {
            UserDefaultsManager.favoriteMovie.append(movieID)
        }
    }
    private func fetchBackdropAndPoster(indexPath: IndexPath) {
        NetworkManager.shared.fetchItem(api: ImageDTO(movieID: output.searchData.value[indexPath.row].id).toRequest(),
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
        let data = output.searchData.value[indexPath.row]
        output.footerData.value = FooterDTO(id: data.id, title: data.title, overview: data.overview, genre_ids: data.genre_ids, release_date: data.release_date, vote_average: data.vote_average)
    }
    private func fetchSynopsis(indexPath: IndexPath) {
        output.synopsisData.value = output.searchData.value[indexPath.row].overview
    }
    private func fetchCast(indexPath: IndexPath) {
        NetworkManager.shared.fetchItem(api: CreditDTO(movieID: output.searchData.value[indexPath.row].id).toRequest(),
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
