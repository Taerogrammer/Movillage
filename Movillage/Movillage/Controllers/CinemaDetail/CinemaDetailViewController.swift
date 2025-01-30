import UIKit

final class CinemaDetailViewController: UIViewController {
    private let cinemaDetailView = CinemaDetailView()
    private let detailSection = ["", "Synopsis", "Cast", "Poster"]

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
            return 5
        case 1:
            return 1
        case 2:
            return 8
        case 3:
            return 8
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackdropCollectionViewCell.id, for: indexPath) as! BackdropCollectionViewCell

            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SynopsisCollectionViewCell.id, for: indexPath) as! SynopsisCollectionViewCell

            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.id, for: indexPath) as! CastCollectionViewCell

            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.id, for: indexPath) as! PosterCollectionViewCell

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
