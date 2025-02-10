import UIKit
import SnapKit

final class ProfileEditView: BaseView {
    let viewModel = ProfileEditViewModel()
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
        viewModel.input.editViewDidLoad.value = ()
    }
}
