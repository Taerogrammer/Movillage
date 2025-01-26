import UIKit
import SnapKit

final class CinemaView: BaseView {

    let profileCardView = ProfileCardView()
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
        return UICollectionViewCompositionalLayout(section: createSectionLayout())
    }
    private func createSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let itemInset: CGFloat = 4
        item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)

        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(160), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(24))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

        section.boundarySupplementaryItems = [header]
        return section
    }




//    static func getLayout() -> UICollectionViewCompositionalLayout {
//      UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
//        switch section {
//        case 0:
//          let itemFractionalWidthFraction = 1.0 / 3.0 // horizontal 3개의 셀
//          let groupFractionalHeightFraction = 1.0 / 4.0 // vertical 4개의 셀
//          let itemInset: CGFloat = 2.5
//
//          // Item
//          let itemSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(itemFractionalWidthFraction),
//            heightDimension: .fractionalHeight(1)
//          )
//          let item = NSCollectionLayoutItem(layoutSize: itemSize)
//          item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
//
//          // Group
//          let groupSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1),
//            heightDimension: .fractionalHeight(groupFractionalHeightFraction)
//          )
//          let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//
//          // Section
//          let section = NSCollectionLayoutSection(group: group)
//          section.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
//          return section
//        default:
//          let itemFractionalWidthFraction = 1.0 / 5.0 // horizontal 5개의 셀
//          let groupFractionalHeightFraction = 1.0 / 4.0 // vertical 4개의 셀
//          let itemInset: CGFloat = 2.5
//
//          // Item
//          let itemSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(itemFractionalWidthFraction),
//            heightDimension: .fractionalHeight(1)
//          )
//          let item = NSCollectionLayoutItem(layoutSize: itemSize)
//          item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
//
//          // Group
//          let groupSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1),
//            heightDimension: .fractionalHeight(groupFractionalHeightFraction)
//          )
//          let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//
//          // Section
//          let section = NSCollectionLayoutSection(group: group)
//          section.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
//          return section
//        }
//      }
//    }


}
