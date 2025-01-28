import UIKit
import SnapKit

final class ProfileView: BaseView {
    let imageView = ProfileImage(frame: CGRect())
    private let cameraImage = UIImageView()
    let textField = UITextField()
    private let textInfoLabel = UILabel().setFont(.description)
    let completeButton = CustomButton()
    var imageIndex: Int? {
        didSet { updateProfileImage() }
    }

    override func configureHierarchy() {
        [imageView, textField, textInfoLabel, completeButton, cameraImage].forEach { addSubview($0) }
    }
    override func configureLayout() {
        imageView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(24)
            $0.centerX.equalToSuperview()
            // 추후 변경
            $0.width.height.equalTo(80)
        }
        textField.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(24)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        textInfoLabel.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(40)
            $0.leading.equalTo(textField).inset(12)
        }
        completeButton.snp.makeConstraints {
            $0.top.equalTo(textInfoLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        cameraImage.snp.makeConstraints {
            $0.trailing.equalTo(imageView)
            $0.bottom.equalTo(imageView)
        }

    }
    override func configureView() {
        imageView.isEnabledOrHighlighted(isHighlighted: true)
        textField.placeholder = "닉네임을 입력해주세요"
        completeButton.setTitle("완료", for: .normal)
        cameraImage.image = UIImage(systemName: "camera.circle.fill")
        cameraImage.tintColor = UIColor.customBlue
        textInfoLabel.textColor = UIColor.customBlue
        completeButton.isEnabled = false

        // userDefaults 없을 때 호출
        [getProfileImage(), configureDelegate(), configureTextField()].forEach { $0 }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        textField.underlined(viewSize: textField.frame.width, color: UIColor.customGray)
    }
}

// MARK: method
extension ProfileView {
    private func getProfileImage() {
        if UserDefaultsManager.profileImage == nil {
            getRandomImage()
        } else {
            imageView.image = UIImage(named: UserDefaultsManager.profileImage ?? "profile_0")
        }
    }
    /// userDefaults에 프로필 이미지 설정이 없을 때 랜덤으로 보여주기
    private func getRandomImage() {
        self.imageIndex = (0...11).randomElement()!
        imageView.image = UIImage(named: "profile_\(imageIndex ?? 0)")
    }
    private func updateProfileImage() {
        guard let index = imageIndex else { return }
        imageView.image = UIImage(named: "profile_\(index)")
    }
    private func containsSpecialCharacter(text: String) -> Bool {
        return text.contains("@") || text.contains("#") || text.contains("$") || text.contains("%")
    }
    private func containsNumber(text: String) -> Bool {
        return text.filter({ $0.isNumber }).count > 0
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
        guard let text = textField.text else { return }

        /// 문구는 글자 수가 특수문자보다 우선순위로 두어, 만약 두 조건을 위배한다면 글자 수 관련 문구가 나타납니다.
        if text.count < 2 || text.count >= 10 {
            textInfoLabel.text = "2글자 이상 10글자 미만으로 설정해주세요"
            completeButton.isEnabled = false
        } else if containsSpecialCharacter(text: text) {
            textInfoLabel.text = "닉네임에 @, #, $, % 는 포함할 수 없어요"
            completeButton.isEnabled = false
        } else if containsNumber(text: text) {
            textInfoLabel.text = "닉네임에 숫자는 포함할 수 없어요"
            completeButton.isEnabled = false
        } else {
            textInfoLabel.text = "사용할 수 있는 닉네임이에요"
            completeButton.isEnabled = true
        }
    }
}
