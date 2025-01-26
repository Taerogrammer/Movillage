import UIKit

final class CinemaViewController: UIViewController {

    private let cinemaView = CinemaView()

    let dummySection = ["최근검색어", "오늘의 영화"]
    let dummySectionOne = ["스파이더맨", "배트맨", "슈퍼맨", "아이언맨", "인크레더블 헐크", "되게 긴 외국 영화"]
    let dummySectionTwo: [TodayMovie] = [
        TodayMovie(posterImage: "heart", title: "스파이더맨", description: "이ㅏㅁ누리ㅏㅜㅇ히마ㅜ힝누링나ㅜ리ㅏ루지다륑나루이나룽ㄴ"),
        TodayMovie(posterImage: "star.fill", title: "인크레더블 헐크", description: "민움니ㅏ움니ㅏㅇ루이ㅏ후민아훋재루ㅐㅈ라ㅜㅇ내ㅏㅁ룬애ㅏㅜㄴ애라ㅜㄴ애ㅏ루"),
        TodayMovie(posterImage: "person", title: "하얼빈", description: "ㅣㅁ나ㅜ리ㅏㄴ울미ㅏㅜ이ㅏ루미라운리ㅏㅜ디라ㅜ23ㅐㅑ루잳루ㅐ두래ㅑ2루2ㅐ3ㅑ룯ㄹ")
    ]

    override func loadView() {
        super.loadView()
        view = cinemaView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        [configureNavigation(), configureProfileCard(),configureDelegate()].forEach { $0 }
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
            return dummySectionTwo.count
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
            return cell
        default:
            return UICollectionViewCell()
        }

    }
    

}

// MARK: configure delegate
extension CinemaViewController: DelegateConfiguration {
    func configureDelegate() {
        cinemaView.collectionView.delegate = self
        cinemaView.collectionView.dataSource = self
        cinemaView.collectionView.register(TodayMovieCollectionViewCell.self, forCellWithReuseIdentifier: TodayMovieCollectionViewCell.id)
        cinemaView.collectionView.register(RecentSearchCollectionViewCell.self, forCellWithReuseIdentifier: RecentSearchCollectionViewCell.id)
    }
}
