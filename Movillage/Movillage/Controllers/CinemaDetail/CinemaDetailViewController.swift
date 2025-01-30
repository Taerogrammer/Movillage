import UIKit

final class CinemaDetailViewController: UIViewController {
    private let cinemaDetailView = CinemaDetailView()
    private let detailSection = ["", "Synopsis", "Cast", "Poster"]
    var backdropArray: [String]? {
        /// completionHandler로 값을 받기 때문에 이미 메인 스레드에서 실행됨 -> main.async에서 호출하면 에러 발생
        didSet {
            self.cinemaDetailView.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    var footerDTO: FooterDTO = FooterDTO(overview: "", genre_ids: [], release_date: "", vote_average: 0.0) {
        didSet {
            /// global().aync에서 값을 변경하였기 때문에 UI 업데이트를 위해 main.async에서 수행
            /// (수행하지 않으면 에러 발생)
            DispatchQueue.main.async {
                self.cinemaDetailView.collectionView.reloadSections(IndexSet(integer: 0))
            }
            print("GGG ", footerDTO.genre_ids)
        }
    }
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
        title = "상세 정보"
        [configureDelegate()].forEach { $0 }        
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
            return header
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CinemaDetailFooterView.id, for: indexPath) as! CinemaDetailFooterView

            footer.configureCell(with: footerDTO)

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
