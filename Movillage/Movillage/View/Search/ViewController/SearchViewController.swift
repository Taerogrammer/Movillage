import UIKit

final class SearchViewController: UIViewController {
    let viewModel = SearchViewModel()
    let searchView = SearchView()

    override func loadView() {
        view = searchView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        [configureNavigation(), configureDelegate(), bindData()].forEach { $0 }
        searchView.searchBar.becomeFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.viewWillAppear.value = ()
    }
}

// MARK: - bind
extension SearchViewController: ViewModelBind {
    func bindData() {
        viewModel.output.notFoundLabelVisible.lazyBind { [weak self] bool in
            self?.searchView.notFoundLabel.isHidden = !bool
            self?.searchView.searchTableView.isHidden = bool
        }
        viewModel.output.searchData.lazyBind { [weak self] response in
            self?.searchView.searchTableView.reloadData()
        }
        viewModel.output.indexPath.lazyBind { [weak self] indexPath in
            self?.searchView.searchTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

//MARK: configure table view
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.searchData.value.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id) as! SearchTableViewCell
        cell.configureCell(with: viewModel.output.searchData.value[indexPath.row])
        cell.didLikeButtonTapped = {
            self.viewModel.input.clickedId.value = self.viewModel.output.searchData.value[indexPath.row].id
            UIView.performWithoutAnimation {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = CinemaDetailViewController()
        viewModel.input.clickedIndexPath.value = indexPath
        /// backdrop, poster
        viewModel.output.backdropArray.lazyBind { backdrops in
            vc.backdropArray = backdrops
        }
        viewModel.output.posterArray.lazyBind { posters in
            vc.posterArray = posters
        }
        /// results - overview, genre_ids, release_date, vote_average
        vc.footerDTO = viewModel.output.footerData.value
        /// Synopsis
        vc.synopsisDTO = viewModel.output.synopsisData.value
        /// cast
        viewModel.output.castData.lazyBind { casts in
            vc.castDTO = casts
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
        if contentOffsetY > tableViewHeight - pagination && viewModel.input.searchDTO.value.page < viewModel.output.searchResponse.value.total_pages {
            viewModel.input.loadMoreDataTrigger.value = ()
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
        viewModel.input.searchText.value = searchBar.text!
        view.endEditing(true)
        // 상태바 누르면 top으로 이동
        searchView.searchTableView.scrollsToTop = true
        // tableview가 생기기도 전에 스크롤을 하려고해서 문제가 발생할 수 있음
        // tableview의 y offset이 0보다 크면 어쨋든 존재하기 때문에 scrollToRow 가능
        if searchView.searchTableView.contentOffset.y > 0 {
            searchView.searchTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
}
