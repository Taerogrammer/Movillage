import UIKit

final class CinemaViewController: UIViewController {
    private let cinemaView = CinemaView()
    private let cinemaSection = ["최근검색어", "오늘의 영화"]
    private var trendingDTO = TrendingDTO()
    private var trendingMovie = TrendingResponse(page: 1, results: []) {
        didSet {
            DispatchQueue.main.async {
                self.cinemaView.collectionView.reloadSections(IndexSet(integer: 1))
            }
        }
    }

    override func loadView() {
        super.loadView()
        view = cinemaView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        [configureNavigation(), configureProfileCard(),configureDelegate(), configureNotification()].forEach { $0 }
        DispatchQueue.global().async {
            self.fetchTrending()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.sendDataToCollectionView()
            self.cinemaView.collectionView.reloadData()
            self.getFavoriteMovieCount() // 무비박스 불러오기
        }
    }
}

// MARK: configure navigation
extension CinemaViewController: NavigationConfiguration {
    func configureNavigation() {
        navigationItem.title = "오늘의 영화"
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchTapped))
        searchButton.tintColor = UIColor.customBlue
        navigationItem.rightBarButtonItem = searchButton
    }
}

// MARK: configure profile card
extension CinemaViewController: ProfileCardViewGesture {
    func configureProfileCard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileCardTapped))
        cinemaView.profileCardView.addGestureRecognizer(tapGesture)
    }
}

// MARK: @objc
extension CinemaViewController {
    @objc private func searchTapped() {
        let vc = SearchViewController()
        navigationController?.pushViewController(vc, animated: true)
        setEmptyTitleBackButton()
    }
    @objc private func updatedProfileReceived() {
        cinemaView.profileCardView.profileImage.image = UIImage(named: UserDefaultsManager.profileImage ?? "profile_0")
        cinemaView.profileCardView.nicknameLabel.text = UserDefaultsManager.nickname
    }
    @objc func profileCardTapped() {
        let navVC = UINavigationController(rootViewController: ProfileEditViewController())
        if let sheet = navVC.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        present(navVC, animated: true)
    }
}

// MARK: configure collection view
extension CinemaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return cinemaSection.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return max(UserDefaultsManager.recentSearch.count, 1)    // 데이터가 없을 때에도 item의 개수가 1이어야 라벨이 나타남 (0이면 아예 없는 것으로 간주)
        case 1:
            return trendingMovie.results.count
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            if UserDefaultsManager.recentSearch.count == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchEmptyCell.id, for: indexPath) as! RecentSearchEmptyCell
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCollectionViewCell.id, for: indexPath) as! RecentSearchCollectionViewCell
                cell.configureCell(text: UserDefaultsManager.recentSearch[indexPath.item])
                cell.closeButtonDelegate = self
                cell.xButton.tag = indexPath.item

                return cell
            }
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayMovieCollectionViewCell.id, for: indexPath) as! TodayMovieCollectionViewCell

            let item = trendingMovie.results[indexPath.item]
            cell.configureCell(with: item)
            cell.didLikeButtonTapped = {
                let clickedID = self.trendingMovie.results[indexPath.item].id
                // 만약 이미 있으면 제거
                CinemaViewController.didFavoriteTapped(id: clickedID)
                // 깜빡이는 애니메이션 제거
                UIView.performWithoutAnimation {
                    collectionView.reloadItems(at: [indexPath])
                }
                self.getFavoriteMovieCount()
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            // 최근 검색어가 존재할 때에만 클릭 가능
            if UserDefaultsManager.recentSearch.count > 0 {
                let vc = SearchViewController()
                vc.searchView.searchBar.text = UserDefaultsManager.recentSearch[indexPath.item]
                setEmptyTitleBackButton()
                navigationController?.pushViewController(vc, animated: true)
            }
        case 1:
            let vc = CinemaDetailViewController()

            DispatchQueue.global().async {
                /// backdrop, poster
                NetworkManager.shared.fetchItem(api: ImageDTO(movieID: self.trendingMovie.results[indexPath.row].id).toRequest(),
                                                type: ImageResponse.self) { result in
                    switch result {
                    case .success(let success):
                        vc.backdropArray = success.backdrops.prefix(5).map { TMDBUrl.imageUrl + $0.file_path }
                        vc.posterArray = success.posters.map { TMDBUrl.imageUrl + $0.file_path }
                    case .failure(let failure):
                        self.networkErrorAlert(error: failure)
                    }
                }

                let footerData = self.trendingMovie.results[indexPath.item]
                /// results - overview, genre_ids, release_date, vote_average
                vc.footerDTO = FooterDTO(id: footerData.id, title: footerData.title, overview: footerData.overview, genre_ids: footerData.genre_ids, release_date: footerData.release_date, vote_average: footerData.vote_average)
                /// Synopsis
                vc.synopsisDTO = self.trendingMovie.results[indexPath.item].overview
                /// cast
                NetworkManager.shared.fetchItem(api: CreditDTO(movieID: self.trendingMovie.results[indexPath.row].id).toRequest(),
                                                type: CreditResponse.self) { result in
                    switch result {
                    case .success(let success):
                        vc.castDTO = success.cast
                    case .failure(let failure):
                        self.networkErrorAlert(error: failure)
                    }
                }
            }
            setEmptyTitleBackButton()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CinemaHeaderView.id, for: indexPath) as! CinemaHeaderView
        header.configureHeaderTitle(title: cinemaSection[indexPath.section])
        header.configureRemoveButton(title: cinemaSection[indexPath.section])
        if !isDataExists(data: UserDefaultsManager.recentSearch.count) { header.removeButton.isHidden = true }

        header.removeAllRecentSearch = {
            ["recentSearch"].forEach {
                UserDefault<[String]>(key: $0, defaultValue: [], storage: .standard).removeObject()
            }
            self.sendDataToCollectionView()
            collectionView.reloadSections(IndexSet(integer: 0))
        }

        return header
    }
}

// MARK: configure delegate
extension CinemaViewController: DelegateConfiguration {
    func configureDelegate() {
        cinemaView.collectionView.delegate = self
        cinemaView.collectionView.dataSource = self
        cinemaView.collectionView.register(CinemaHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CinemaHeaderView.id)
        cinemaView.collectionView.register(TodayMovieCollectionViewCell.self, forCellWithReuseIdentifier: TodayMovieCollectionViewCell.id)
        cinemaView.collectionView.register(RecentSearchCollectionViewCell.self, forCellWithReuseIdentifier: RecentSearchCollectionViewCell.id)
        cinemaView.collectionView.register(RecentSearchEmptyCell.self, forCellWithReuseIdentifier: RecentSearchEmptyCell.id)
    }
}

// MARK: method
extension CinemaViewController {
    private func fetchTrending() {
        NetworkManager.shared.fetchItem(api: trendingDTO.toRequest(),
                                        type: TrendingResponse.self) { result in
            switch result {
            case .success(let success):
                self.trendingMovie = success
            case .failure(let failure):
                self.networkErrorAlert(error: failure)
            }
        }
    }
    // 최근검색어 여부 전달
    private func sendDataToCollectionView() { print(#function); cinemaView.data = getDataCount(data: UserDefaultsManager.recentSearch) }
    private func isDataExists(data: Int) -> Bool { return data > 0 }
    private func getDataCount(data: [String]) -> Int { return data.count }
    private func getFavoriteMovieCount() {
        print(#function)
        cinemaView.profileCardView.likeCountButton.setTitle("\(UserDefaultsManager.favoriteMovie.count)개의 무비박스 보관중", for: .normal)
    }
}

// MARK: configure notification
extension CinemaViewController: NotificationConfiguration {
    func configureNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updatedProfileReceived), name: NSNotification.Name("updateProfile"), object: nil)
    }
}

// MARK: configure protocol delegate
extension CinemaViewController: RecentSearchCloseDelegate {
    func recentSearchCloseButtonTapped(at index: Int) {
        if UserDefaultsManager.recentSearch.count > 0 {
            UserDefaultsManager.recentSearch.remove(at: index)
            sendDataToCollectionView()
            Task { @MainActor [weak self] in
                guard self != nil else { return }
                UIView.performWithoutAnimation {
                    self?.cinemaView.collectionView.reloadSections(IndexSet(integer: 0))
                }
            }
        }
    }
}
