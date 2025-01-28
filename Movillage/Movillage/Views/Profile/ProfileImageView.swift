import UIKit
import SnapKit

final class ProfileImageView: BaseView {
    let presentImage = ProfileImage(frame: CGRect())
    private let cameraImage = UIImageView()
    lazy var profileImageCollectionView = UICollectionView(frame: .zero,
                                                      collectionViewLayout: configureFlowLayout())

    override func configureHierarchy() {
        [presentImage, cameraImage, profileImageCollectionView].forEach { addSubview($0) }
    }
    override func configureLayout() {
        presentImage.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(24)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(80)
        }
        cameraImage.snp.makeConstraints {
            $0.trailing.equalTo(presentImage)
            $0.bottom.equalTo(presentImage)
        }
        profileImageCollectionView.snp.makeConstraints {
            $0.top.equalTo(presentImage.snp.bottom).offset(32)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(24)
            ///
            $0.height.equalTo(300)
        }
    }
    override func configureView() {
        cameraImage.image = UIImage(systemName: "camera.circle.fill")
        presentImage.didImageSelected(isHighlighted: true)
        cameraImage.tintColor = UIColor.customBlue
        profileImageCollectionView.isScrollEnabled = false
    }
    func configureProfileImage(to profileName: String) {
        presentImage.image = UIImage(named: profileName)
    }
    func configureFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionInset: CGFloat = 16
        let cellSpacing: CGFloat = 16
        let deviceWidth = UIScreen.main.bounds.width

        // 행 당 셀 4개
        let cellWidth = (deviceWidth - (sectionInset * 2) - (cellSpacing * 4)) / 4
        let cellHeight = (deviceWidth - (sectionInset * 2) - (cellSpacing * 4)) / 4

        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        return layout
    }
}
