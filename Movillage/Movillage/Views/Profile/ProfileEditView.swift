import UIKit
import SnapKit

final class ProfileEditView: BaseView {
    let profileView = ProfileView()

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
    }
}
