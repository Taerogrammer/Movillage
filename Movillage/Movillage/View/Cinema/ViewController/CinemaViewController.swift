import UIKit

final class CinemaViewController: UIViewController {
    private let viewModel = CinemaViewModel()
    private let cinemaView = CinemaView()

    override func loadView() {
        super.loadView()
        view = cinemaView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        [configureNavigation(), configureProfileCard(),configureDelegate(), configureNotification(), bindData()].forEach { $0 }
        viewModel.input.viewDidLoad.value = ()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.viewWillAppear.value = ()
        self.cinemaView.collectionView.reloadData()
    }
}

// MARK: - bind
extension CinemaViewController: ViewModelBind {
    func bindData() {
        viewModel.output.trendingMovie.bind { [weak self] _ in
            self?.cinemaView.collectionView.reloadSections(IndexSet(integer: 1))
        }
        viewModel.output.totalMovieBox.bind { [weak self] count in
            self?.cinemaView.profileCardView.likeCountButton.setTitle("\(count)개의 무비박스 보관중", for: .normal)
        }
        viewModel.output.totalData.bind { [weak self] data in
            self?.cinemaView.data = data
        }
        viewModel.output.profileImageName.bind { [weak self] imageName in
            self?.cinemaView.profileCardView.profileImage.image = UIImage(named: imageName)
        }
        viewModel.output.nicknamelabel.bind { [weak self] nickname in
            self?.cinemaView.profileCardView.nicknameLabel.text = nickname
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
        viewModel.input.updateProfile.value = ()
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

        return viewModel.cinemaSection.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            viewModel.input.numberOfItemsInSection.value = ()
            return viewModel.output.numberOfItemsInZeroSection.value    // 데이터가 없을 때에도 item의 개수가 1이어야 라벨이 나타남 (0이면 아예 없는 것으로 간주)
        case 1:
            return viewModel.output.trendingMovie.value.results.count
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        viewModel.input.cellForItemAt.value = ()
        switch indexPath.section {
        case 0:
            if viewModel.output.totalRecentSearch.value == 0 {
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

            let item = viewModel.output.trendingMovie.value.results[indexPath.item]
            cell.configureCell(with: item)
            cell.didLikeButtonTapped = {
                let clickedID = self.viewModel.output.trendingMovie.value.results[indexPath.item].id
                // 만약 이미 있으면 제거
                CinemaViewController.didFavoriteTapped(id: clickedID)
                // 깜빡이는 애니메이션 제거
                UIView.performWithoutAnimation {
                    collectionView.reloadItems(at: [indexPath])
                }
                self.viewModel.input.updateFavoriteMovie.value = ()
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
            viewModel.input.clickedIndexPath.value = indexPath
            /// backdrop, poster
            viewModel.output.backdropArray.lazyBind { backdrops in
                vc.viewModel.input.backdropArray.value = backdrops
            }
            viewModel.output.posterArray.lazyBind { posters in
                vc.viewModel.input.posterArray.value = posters
            }
            /// results - overview, genre_ids, release_date, vote_average
            vc.viewModel.input.footerDTO.value = viewModel.output.footerData.value
            /// Synopsis
            vc.viewModel.input.synopsisDTO.value = viewModel.output.synopsisData.value
            /// cast
            viewModel.output.castData.lazyBind { casts in
                vc.viewModel.input.castDTO.value = casts
            }
            setEmptyTitleBackButton()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CinemaHeaderView.id, for: indexPath) as! CinemaHeaderView
        header.configureHeaderTitle(title: viewModel.cinemaSection[indexPath.section])
        header.configureRemoveButton(title: viewModel.cinemaSection[indexPath.section])

        if UserDefaultsManager.recentSearch.count <= 0 {
            header.removeButton.isHidden = true
        }

        // TODO: - 클로저 이동 필요
        header.removeAllRecentSearch = {
            ["recentSearch"].forEach {
                UserDefault<[String]>(key: $0, defaultValue: [], storage: .standard).removeObject()
            }
            self.viewModel.input.sendDataToCollectionViewTapped.value = ()
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

// MARK: configure notification
extension CinemaViewController: NotificationConfiguration {
    func configureNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updatedProfileReceived), name: NSNotification.Name("updateProfile"), object: nil)
    }
}

// MARK: configure protocol delegate
extension CinemaViewController: RecentSearchCloseDelegate {
    // TODO: 델리게이트 이동
    func recentSearchCloseButtonTapped(at index: Int) {
        if UserDefaultsManager.recentSearch.count > 0 {
            UserDefaultsManager.recentSearch.remove(at: index)
            /// 없애기
            viewModel.input.sendDataToCollectionViewTapped.value = ()
            UIView.performWithoutAnimation {
                self.cinemaView.collectionView.reloadSections(IndexSet(integer: 0))
            }
        }
    }
}
