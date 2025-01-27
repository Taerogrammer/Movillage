import UIKit

final class CinemaViewController: UIViewController {

    private let cinemaView = CinemaView()

    let dummySection = ["최근검색어", "오늘의 영화"]
    let dummySectionOne = ["스파이더맨", "배트맨", "슈퍼맨", "아이언맨", "인크레더블 헐크", "되게 긴 외국 영화"]

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
        [configureNavigation(), configureProfileCard(),configureDelegate()].forEach { $0 }
        DispatchQueue.global().async {
            self.fetchTrending()
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
}

// MARK: configure collection view
extension CinemaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return dummySection.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return dummySectionOne.count
        case 1:
            return trendingMovie.results.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCollectionViewCell.id, for: indexPath) as! RecentSearchCollectionViewCell

            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayMovieCollectionViewCell.id, for: indexPath) as! TodayMovieCollectionViewCell

            let row = trendingMovie.results[indexPath.row]
            cell.configureCell(with: row)

            return cell
        default:
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CinemaHeaderView.id, for: indexPath) as! CinemaHeaderView
        header.configureHeaderTitle(title: dummySection[indexPath.section])
        header.configureRemoveButton(title: dummySection[indexPath.section])

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
}
