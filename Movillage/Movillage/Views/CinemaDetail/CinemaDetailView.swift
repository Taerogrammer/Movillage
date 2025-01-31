import UIKit
import SnapKit

final class CinemaDetailView: BaseView {
    let favoriteButton = UIButton()
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCompositionalLayout())

    override func configureHierarchy() {
        addSubview(collectionView)
    }
    override func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    override func configureView() {
        collectionView.backgroundColor = UIColor.customBlack
        collectionView.showsVerticalScrollIndicator = false
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = UIColor.customBlue
    }
    var presentPage: Int?
    var currentPageChanged: ((Int) -> Void)?

}

// MARK: configure compositional layout
extension CinemaDetailView {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionNumber, env -> NSCollectionLayoutSection? in
            switch sectionNumber {
            case 0:
                return self?.createBackdropSectionLayout()
            case 1:
                return self?.createSynopsisSectionLayout()
            case 2:
                return self?.createCastSectionLayout()
            case 3:
                return self?.createPosterSectionLayout()
            default:
                return self?.createPosterSectionLayout()
            }
        }
    }

    private func createBackdropSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width), heightDimension: .absolute(280))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width), heightDimension: .absolute(280))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered

        section.visibleItemsInvalidationHandler = { items, contentOffset, environment in
            let currentPage = Int(max(0, round(contentOffset.x / UIScreen.main.bounds.width)))
            if self.presentPage != currentPage {
                self.presentPage = currentPage
                self.currentPageChanged?(currentPage)
            }   // 값이 다를 때에만 호출
        }


        // 영화 간략 정보
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)

        section.boundarySupplementaryItems = [footer]
        return section

    }
    private func createSynopsisSectionLayout() -> NSCollectionLayoutSection {
        // item은 하나
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(180))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(180))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        section.boundarySupplementaryItems = [header]

        return section
    }
    private func createCastSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(300), heightDimension: .absolute(80))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // 두 줄
        let verticalSize = NSCollectionLayoutSize(widthDimension: .estimated(300), heightDimension: .absolute(80))
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalSize, repeatingSubitem: item, count: 2)
        verticalGroup.interItemSpacing = .fixed(4)

        let horizontalSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(10.0), heightDimension: .absolute(170))
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalSize, subitems: [verticalGroup])
        horizontalGroup.interItemSpacing = .fixed(12)


        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        section.orthogonalScrollingBehavior = .continuous

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)

        section.boundarySupplementaryItems = [header]
        return section
    }
    private func createPosterSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(260))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(260))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(4)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 2, bottom: 24, trailing: 2)
        section.orthogonalScrollingBehavior = .continuous

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)

        section.boundarySupplementaryItems = [header]
        return section
    }
}
