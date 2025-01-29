import UIKit

final class SearchViewController: UIViewController {

    private let searchView = SearchView()
    private var searchDTO = SearchDTO(query: "", page: 1)
    private var page = 1
    lazy var searchResponse = SearchResponse(page: 1, results: searchData, total_pages: 1, total_results: 1)
    private var searchData: [ResultsResponse] = []

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
        print(#function)
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
        navigationController?.pushViewController(vc, animated: true)
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
        print(#function, searchBar.text!)
        let searchText = searchBar.text!
        UserDefaultsManager.recentSearch.removeAll { $0 == searchText } // 중복 제거
        UserDefaultsManager.recentSearch.insert(searchBar.text!, at: 0)
        view.endEditing(true)
        searchDTO.query = searchBar.text!
        searchDTO.page = self.page

        DispatchQueue.global().async {
            NetworkManager.shared.fetchItem(api: self.searchDTO.toRequest(),
                                            type: SearchResponse.self) { result in
                switch result {
                case .success(let success):
                    self.searchResponse = success
                    self.searchData = success.results
                    DispatchQueue.main.async {
                        self.notFoundLabelVisibility()
                        self.searchView.searchTableView.reloadData()
                    }
                case .failure(let failure):
                    print("실패 ", failure)
                }
            }
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
