import UIKit
import SnapKit

final class ProfileEditView: BaseView {
    private let titleBar = UILabel().setFont(.header)
    let closeButton = UIButton()
    let saveButton = UIButton()
    let profileView = ProfileView()

    override func configureHierarchy() {
        [closeButton, titleBar, saveButton, profileView].forEach { addSubview($0) }
    }
    override func configureLayout() {
        closeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalTo(titleBar)
        }
        titleBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
        saveButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(titleBar)
        }
        profileView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.top.equalTo(titleBar.snp.bottom)
        }
    }
    override func configureView() {
        profileView.completeButton.isHidden = true
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = UIColor.customBlue
        titleBar.text = "프로필 편집"
        saveButton.setTitle("저장", for: .normal)
        saveButton.titleLabel?.font = UIFont.header
        saveButton.setTitleColor(UIColor.customBlue, for: .normal)
    }
}
