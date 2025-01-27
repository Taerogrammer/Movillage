import UIKit

final class SearchViewController: UIViewController {

    private let searchView = SearchView()
    private var searchDTO = SearchDTO(query: "", page: 1)
    private var page = 1

    override func loadView() {
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        [configureNavigation(), configureDelegate()].forEach { $0 }
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
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function, searchBar.text!)
        searchDTO.query = searchBar.text!
        searchDTO.page = self.page

        NetworkManager.shared.fetchItem(api: searchDTO.toRequest(),
                                        type: SearchResponse.self) { result in
            switch result {
            case .success(let success):
                print("성공 -> ", success)
            case .failure(let failure):
                print("실패 ", failure)
            }
        }
    }
}
