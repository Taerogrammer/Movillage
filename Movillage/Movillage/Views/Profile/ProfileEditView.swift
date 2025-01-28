import UIKit
import SnapKit

final class ProfileEditView: BaseView {
    let profileView = ProfileView()
    var imageIndex: Int?

    override func configureHierarchy() {
        [profileView].forEach { addSubview($0) }
    }
    override func configureLayout() {
        profileView.snp.makeConstraints {
            $0.edges.bottom.equalToSuperview()
        }
    }
    override func configureView() {
        profileView.completeButton.isHidden = true

        [getProfileImage()].forEach { $0 }
    }
}

extension ProfileEditView {
    private func getProfileImage() {
        profileView.imageView.image = UIImage(named: UserDefaultsManager.profileImage ?? "profile_0")
        guard let candidateIndex = UserDefaultsManager.profileImage else { return }
        let index = candidateIndex.filter { $0.isNumber }
        self.imageIndex = Int(index)
    }
}
