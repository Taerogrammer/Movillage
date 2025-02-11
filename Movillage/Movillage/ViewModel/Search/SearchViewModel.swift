import Foundation

final class SearchViewModel: BaseViewModel {
    private(set) var input: Input
    private(set) var output: Output

    struct Input {
        let searchText: Observable<String> = Observable("")
        let searchDTO: Observable<SearchDTO> = Observable(SearchDTO(query: "", page: 1))
        let loadMoreDataTrigger: Observable<Void> = Observable(())
    }
    struct Output {
        let searchResponse: Observable<SearchResponse> = Observable(SearchResponse(page: 1, results: [ResultsResponse](), total_pages: 1, total_results: 1))
        let searchData: Observable<[ResultsResponse]> = Observable([])
        let notFoundLabelVisible: Observable<Bool> = Observable(false)
    }

    init() {
        input = Input()
        output = Output()

        transform()
    }
    func transform() {
        input.searchText.lazyBind { [weak self] query in
            self?.configureUserDefaultsRecentSearch(text: query)
            self?.resetPage()
            self?.input.searchDTO.value.query = query
            self?.fetchSearchData()
        }
        input.loadMoreDataTrigger.lazyBind { [weak self] _ in
            self?.loadMoreData()
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

}
