import UIKit

final class CinemaDetailViewController: UIViewController {
    private let cinemaDetailView = CinemaDetailView()
    private let detailSection = ["", "Synopsis", "Cast", "Poster"]
    var backdropArray: [String]? {
        /// completionHandler로 값을 받기 때문에 이미 메인 스레드에서 실행됨 -> main.async에서 호출하면 에러 발생
        /// 첫 호출 때는 없기 때문에 didSet으로 감지를 적용해야 함
        didSet {
            self.cinemaDetailView.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    var footerDTO: FooterDTO = FooterDTO(id: 0, title: "", overview: "", genre_ids: [], release_date: "", vote_average: 0.0)
    var synopsisDTO: String = ""
    // false -> 3줄 (More Tapped가 false)
    var isMoreTapped = false

    var posterArray: [String]? {
        didSet {
            self.cinemaDetailView.collectionView.reloadSections(IndexSet(integer: 3))
        }
    }

    override func loadView() {
        view = cinemaDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        [configureDelegate(), configureNavigation(), favoriteButtonColorChanged()].forEach { $0 }
    }
}

// MARK: configure collection view
extension CinemaDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return detailSection.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return backdropArray?.count ?? 0
        case 1:
            return 1
        case 2:
            return 8
        case 3:
            return posterArray?.count ?? 0
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackdropCollectionViewCell.id, for: indexPath) as! BackdropCollectionViewCell

            cell.configureImageCell(with: backdropArray?[indexPath.item])

            

            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SynopsisCollectionViewCell.id, for: indexPath) as! SynopsisCollectionViewCell

            cell.configureCell(with: synopsisDTO)
            cell.synopsisLabel.numberOfLines = isMoreTapped ? 0 : 3

            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.id, for: indexPath) as! CastCollectionViewCell

            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.id, for: indexPath) as! PosterCollectionViewCell

            cell.configureImageCell(with: posterArray?[indexPath.item])

            return cell
        default:
            return UICollectionViewCell()
        }
    }

    // header, footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CinemaDetailHeaderView.id, for: indexPath) as! CinemaDetailHeaderView

            header.configureHeaderTitle(title: detailSection[indexPath.section])
            header.configureMoreButton(title: detailSection[indexPath.section])

            header.moreButtonToggle = {
                self.isMoreTapped.toggle()
                header.moreButton.setTitle(self.isMoreTapped ? "Hide" : "More", for: .normal)
                self.cinemaDetailView.collectionView.reloadItems(at: [indexPath])
            }
            return header
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CinemaDetailFooterView.id, for: indexPath) as! CinemaDetailFooterView

            footer.configureCell(with: footerDTO)
            footer.pageControl.numberOfPages = backdropArray?.count ?? 5

            cinemaDetailView.currentPageChanged = { value in
                footer.pageControl.currentPage = value
            }

            return footer
        }
    }
}

// MARK: configure delegate
extension CinemaDetailViewController: DelegateConfiguration {
    func configureDelegate() {
        cinemaDetailView.collectionView.delegate = self
        cinemaDetailView.collectionView.dataSource = self
        cinemaDetailView.collectionView.register(BackdropCollectionViewCell.self, forCellWithReuseIdentifier: BackdropCollectionViewCell.id)
        cinemaDetailView.collectionView.register(SynopsisCollectionViewCell.self, forCellWithReuseIdentifier: SynopsisCollectionViewCell.id)
        cinemaDetailView.collectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.id)
        cinemaDetailView.collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.id)
        // header, footer
        cinemaDetailView.collectionView.register(CinemaDetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CinemaDetailHeaderView.id)
        cinemaDetailView.collectionView.register(CinemaDetailFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CinemaDetailFooterView.id)
    }
}

// MARK: configure navigation
extension CinemaDetailViewController: NavigationConfiguration {
    func configureNavigation() {
        title = footerDTO.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cinemaDetailView.favoriteButton)
        cinemaDetailView.favoriteButton.addTarget(self, action: #selector(likeBarButtonTapped), for: .touchUpInside)
    }
    private func favoriteButtonColorChanged() {
        let isFavorite = UserDefaultsManager.favoriteMovie.contains(footerDTO.id)
        cinemaDetailView.favoriteButton.setImage(UIImage(systemName: isFavorite ? "heart.fill" : "heart"), for: .normal)
    }
}

// MARK: @objc
extension CinemaDetailViewController {
    @objc private func likeBarButtonTapped() {
        CinemaDetailViewController.didFavoriteTapped(id: footerDTO.id)
        favoriteButtonColorChanged()
    }
}
