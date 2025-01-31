import UIKit

final class SearchViewController: UIViewController {

    let searchView = SearchView()
    private var searchDTO = SearchDTO(query: "", page: 1)
    private var totalPages = 1
    lazy var searchResponse = SearchResponse(page: 1, results: searchData, total_pages: 1, total_results: 1)
    private var searchData: [ResultsResponse] = [] {
        didSet { searchView.searchTableView.reloadData() }
    }

    // TODO: 위치 수정
    let imageUrl = "https://image.tmdb.org/t/p/original"

    override func loadView() {
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        [configureNavigation(), configureDelegate()].forEach { $0 }
        searchView.searchBar.becomeFirstResponder()
    }
}

//MARK: configure table view
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id) as! SearchTableViewCell
        cell.configureCell(with: searchData[indexPath.row])

        // TODO: 모듈화
        cell.didLikeButtonTapped = {
            let clickedID = self.searchData[indexPath.row].id
            if UserDefaultsManager.favoriteMovie.contains(clickedID) {
                UserDefaultsManager.favoriteMovie.removeAll(where: { $0 == clickedID })
            } else {
                UserDefaultsManager.favoriteMovie.append(clickedID)
            }
            UIView.performWithoutAnimation {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = CinemaDetailViewController()
        print("id ", searchData[indexPath.row])

        DispatchQueue.global().async {
            /// backdrop, poster
            NetworkManager.shared.fetchItem(api: ImageDTO(movieID: self.searchData[indexPath.row].id).toRequest(), type: ImageResponse.self) { result in
                switch result {
                case .success(let success):
                    vc.backdropArray = success.backdrops.prefix(5).map { self.imageUrl + $0.file_path }
                    vc.posterArray = success.posters.map { self.imageUrl + $0.file_path }
                case .failure(let failure):
                    print("실패 ", failure)
                }
            }

            let footerData = self.searchResponse.results[indexPath.row]
            /// results - overview, genre_ids, release_date, vote_average
            vc.footerDTO = FooterDTO(id: footerData.id, title: footerData.title, overview: footerData.overview, genre_ids: footerData.genre_ids, release_date: footerData.release_date, vote_average: footerData.vote_average)

            /// Synopsis
            vc.synopsisDTO = self.searchResponse.results[indexPath.row].overview

            /// cast
            NetworkManager.shared.fetchItem(api: CreditDTO(movieID: self.searchResponse.results[indexPath.row].id).toRequest(), type: CreditResponse.self) { result in
                switch result {
                case .success(let success):
                    vc.castDTO = success.cast
                case .failure(let failure):
                    print("실패 ", failure)
                }
            }
        }
        setEmptyTitleBackButton()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: configure pagination
extension SearchViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let tableViewHeight = searchView.searchTableView.contentSize.height
        let pagination = tableViewHeight * 0.2

        // 스크롤 80%일 때와 전체 페이지보다 작을 때 데이터 로드
        if contentOffsetY > tableViewHeight - pagination && searchDTO.page < totalPages {
            loadMoreData()
        }
    }
    private func resetPage() { self.searchDTO.page = 1 }
    private func loadMoreData() {
        self.searchDTO.page += 1
        NetworkManager.shared.fetchItem(api: self.searchDTO.toRequest(),
                                        type: SearchResponse.self) { result in
            switch result {
            case .success(let success):
                self.searchData.append(contentsOf: success.results)
            case .failure(let failure):
                print("실패 -> ", failure)
            }
        }
    }
}

// MARK: configure navigation
extension SearchViewController: NavigationConfiguration {
    func configureNavigation() {
        navigationItem.title = "영화 검색"
    }
}

// MARK: configure delegate
extension SearchViewController: DelegateConfiguration {
    func configureDelegate() {
        searchView.searchBar.delegate = self
        searchView.searchTableView.delegate = self
        searchView.searchTableView.dataSource = self
        searchView.searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.id)
    }
}

// MARK: configure search bar
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text!
        UserDefaultsManager.recentSearch.removeAll { $0 == searchText } // 중복 제거
        UserDefaultsManager.recentSearch.insert(searchBar.text!, at: 0)
        view.endEditing(true)
        searchDTO.query = searchBar.text!
        resetPage()
        DispatchQueue.global().async {
            NetworkManager.shared.fetchItem(api: self.searchDTO.toRequest(),
                                            type: SearchResponse.self) { result in
                switch result {
                case .success(let success):
                    self.searchResponse = success
                    self.searchData = success.results
                    self.totalPages = success.total_pages
                    DispatchQueue.main.async {
                        self.notFoundLabelVisibility()
                    }
                case .failure(let failure):
                    print("실패 ", failure)
                }
            }
        }
        // 상태바 누르면 top으로 이동
        searchView.searchTableView.scrollsToTop = true
        // tableview가 생기기도 전에 스크롤을 하려고해서 문제가 발생할 수 있음
        // tableview의 y offset이 0보다 크면 어쨋든 존재하기 때문에 scrollToRow 가능
        if searchView.searchTableView.contentOffset.y > 0 {
            searchView.searchTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
}

// MARK: method
extension SearchViewController {
    private func notFoundLabelVisibility() {
        if searchData.count == 0 {
            searchView.notFoundLabel.isHidden = false
            searchView.searchTableView.isHidden = true
        } else {
            searchView.notFoundLabel.isHidden = true
            searchView.searchTableView.isHidden = false
        }
    }
}
