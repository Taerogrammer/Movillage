import UIKit
import SnapKit

final class ProfileImageView: BaseView {
    private let presentImage = ProfileImage(frame: CGRect())
    private let cameraImage = UIImageView()

    var imageIndex: Int? {
        didSet { updateImage() }
    }

    override func configureHierarchy() {
        [presentImage, cameraImage].forEach { addSubview($0) }
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
    }
    override func configureView() {
        cameraImage.image = UIImage(systemName: "camera.circle.fill")
        presentImage.backgroundColor = .customBlack
        cameraImage.tintColor = UIColor.customBlue
    }
    func updateImage() {
        guard let index = imageIndex else { return }
        presentImage.image = UIImage(named: "profile_\(index)")
    }
}
