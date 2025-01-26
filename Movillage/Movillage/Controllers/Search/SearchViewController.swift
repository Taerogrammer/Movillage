import UIKit

final class SearchViewController: UIViewController {

    private let searchView = SearchView()

    override func loadView() {
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        [configureNavigation()].forEach { $0 }
    }
}

// MARK: configure navigation
extension SearchViewController: NavigationConfiguration {
    func configureNavigation() {
        navigationItem.title = "영화 검색"
    }
}
