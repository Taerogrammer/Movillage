import UIKit
import SnapKit

final class ProfileView: BaseView {
    let viewModel = ProfileViewModel()
    let imageView = ProfileImage(frame: CGRect())
    private let cameraImage = UIImageView()
    let textField = UITextField()
    let textInfoLabel = UILabel().setFont(.description)
    let completeButton = RoundedButton()
    private let mbtiLabel = UILabel().setFont(.header)
    lazy var mbtiCollectionView = UICollectionView(frame: .zero,
                                                      collectionViewLayout: createFlowLayout())

    override func configureHierarchy() {
        [imageView, textField, textInfoLabel, completeButton, cameraImage, mbtiLabel, mbtiCollectionView].forEach { addSubview($0) }
    }
    override func configureLayout() {
        imageView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(24)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(80)
        }
        cameraImage.snp.makeConstraints {
            $0.trailing.equalTo(imageView)
            $0.bottom.equalTo(imageView)
        }
        textField.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(24)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        textInfoLabel.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(40)
            $0.leading.equalTo(textField).inset(12)
        }
        mbtiLabel.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(84)
            $0.leading.equalTo(textField)
        }
        mbtiCollectionView.snp.makeConstraints {
            $0.top.equalTo(mbtiLabel)
            $0.leading.equalTo(mbtiLabel.snp.trailing).offset(36)
            $0.height.equalTo(160)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(12)
        }
        completeButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(44)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
        }

    }
    override func configureView() {
        imageView.isEnabledOrHighlighted(isHighlighted: true)
        textField.placeholder = "닉네임을 입력해주세요"
        completeButton.setTitle("완료", for: .normal)
        cameraImage.image = UIImage(systemName: "camera.circle.fill")
        cameraImage.tintColor = UIColor.customBlue
        textInfoLabel.textColor = UIColor.customBlue
        mbtiLabel.text = "MBTI"
        completeButton.isEnabled = false
        mbtiCollectionView.allowsMultipleSelection = true

        // userDefaults 없을 때 호출
        [configureDelegate(), configureTextField()].forEach { $0 }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        textField.underlined(viewSize: textField.frame.width, color: UIColor.customGray)
    }
    private func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionInset: CGFloat = 16
        let cellSpacing: CGFloat = 16
        let deviceWidth = UIScreen.main.bounds.width

        // 행 당 셀 4개
        let cellWidth = ((deviceWidth - (sectionInset * 2)   - (cellSpacing   * 4)) / 4) - 20
        let cellHeight = ((deviceWidth - (sectionInset * 2) - (cellSpacing   * 4)) / 4) - 20

        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        return layout
    }
}

// MARK: delegate
extension ProfileView: DelegateConfiguration {
    func configureDelegate() {
        textField.delegate = self
    }
}

// MARK: text field delegate
extension ProfileView: UITextFieldDelegate {
    func configureTextField() {
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
}

// MARK: @objc
extension ProfileView {
    @objc private func textFieldDidChange(_ textField: UITextField) {
        viewModel.inputNicknameText.value = textField.text
    }
}
