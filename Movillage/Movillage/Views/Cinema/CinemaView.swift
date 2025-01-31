import UIKit
import SnapKit

final class CinemaView: BaseView {

    let profileCardView = ProfileCardView()
    // data 개수에 따라서 처음에 초기화 진행하기
    var data: Int?
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCompositionalLayout())

    override func configureHierarchy() {
        [profileCardView, collectionView].forEach { addSubview($0) }
    }
    override func configureLayout() {
        profileCardView.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(self.safeAreaLayoutGuide).inset(8)
            $0.height.greaterThanOrEqualTo(136)
        }
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.top.equalTo(profileCardView.snp.bottom)
        }
    }

    override func configureView() {
        collectionView.isScrollEnabled = false
    }

    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionNumber, env -> NSCollectionLayoutSection? in
            switch sectionNumber {
            case 0:
                return self?.createRecentSearchSectionLayout()
            case 1:
                return self?.createTodayMovieSectionLayout()
            default:
                return self?.createTodayMovieSectionLayout()
            }
        }
    }

    private func createRecentSearchSectionLayout() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: self.data == nil || self.data == 0 ? .fractionalWidth(1.0) : .estimated(66), heightDimension: .absolute(40))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: self.data == nil || self.data == 0 ? .fractionalWidth(1.0) : .fractionalWidth(3.0), heightDimension: .estimated(54))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(16)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        section.interGroupSpacing = 8
        section.orthogonalScrollingBehavior = UserDefaultsManager.recentSearch.isEmpty ? .none : .continuous

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

        section.boundarySupplementaryItems = [header]
        return section
    }
    private func createTodayMovieSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .fractionalHeight(0.8))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(18.0), heightDimension: .fractionalHeight(0.9))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(12)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}
