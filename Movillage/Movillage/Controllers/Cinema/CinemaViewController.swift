import UIKit

final class CinemaViewController: UIViewController {

    private let cinemaView = CinemaView()

    private let cinemaSection = ["최근검색어", "오늘의 영화"]
    var dummySectionOne: [String] = ["ㄴ미루니ㅏ", "ㅐ2ㅑ1개ㅑ쥬"]

    // TODO: 위치 수정
    let imageUrl = "https://image.tmdb.org/t/p/original"

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
            self.cinemaView.collectionView.reloadSections(IndexSet(integer: 0)) // 최근검색어 불러오기
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
    @objc func profileCardTapped() {
        let navVC = UINavigationController(rootViewController: ProfileEditViewController())
        if let sheet = navVC.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        present(navVC, animated: true)
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

                return cell
            }
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayMovieCollectionViewCell.id, for: indexPath) as! TodayMovieCollectionViewCell

            let row = trendingMovie.results[indexPath.row]
            cell.configureCell(with: row)

            return cell
        default:
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if UserDefaultsManager.recentSearch.count > 0 {
                UserDefaultsManager.recentSearch.remove(at: indexPath.item)
                sendDataToCollectionView()
                Task { @MainActor [weak self] in
                    guard self != nil else { return }
                    UIView.performWithoutAnimation {
                        collectionView.reloadSections(IndexSet(integer: 0))
                    }
                }
            }
        case 1:
            let vc = CinemaDetailViewController()
            let detailView = CinemaDetailView()

            NetworkManager.shared.fetchItem(api: ImageDTO(movieID: trendingMovie.results[indexPath.row].id).toRequest(),
                                            type: ImageResponse.self) { result in
                switch result {
                case .success(let success):
                    var array: [String] = []
                    for i in 0..<5 {
                        array.append(self.imageUrl + success.backdrops[i].file_path)
                    }
                    detailView.backdropArray = array
                case .failure(let failure):
                    print("실패 ", failure)
                }
            }
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
                print(failure)
            }
        }
    }
    // 최근검색어 여부 전달
    private func sendDataToCollectionView() { cinemaView.data = getDataCount(data: UserDefaultsManager.recentSearch) }
    private func isDataExists(data: Int) -> Bool { return data > 0 }
    private func getDataCount(data: [String]) -> Int { return data.count }
}

// MARK: configure notification
extension CinemaViewController: NotificationConfiguration {
    func configureNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updatedProfileReceived), name: NSNotification.Name("updateProfile"), object: nil)
    }
}
