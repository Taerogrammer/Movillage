import UIKit
import Kingfisher

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
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id) as! SearchTableViewCell
        cell.configureCell(with: searchData[indexPath.row])
        return cell
    }
}

// MARK: configure navigation
extension SearchViewController: NavigationConfiguration {
    func configureNavigation() {
        navigationItem.title = "영화 검색"
    }
}

extension SearchViewController: DelegateConfiguration {
    func configureDelegate() {
        searchView.searchBar.delegate = self
        searchView.searchTableView.delegate = self
        searchView.searchTableView.dataSource = self
        searchView.searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.id)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function, searchBar.text!)
        view.endEditing(true)
        searchDTO.query = searchBar.text!
        searchDTO.page = self.page

        NetworkManager.shared.fetchItem(api: searchDTO.toRequest(),
                                        type: SearchResponse.self) { result in
            switch result {
            case .success(let success):
                self.searchResponse = success
                self.searchData = success.results
                self.searchView.searchTableView.reloadData()
            case .failure(let failure):
                print("실패 ", failure)
            }
        }
    }
}
