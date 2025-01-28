import UIKit
import SnapKit

final class ProfileView: BaseView {
    let imageView = ProfileImage(frame: CGRect())
    private let cameraImage = UIImageView()
    let textField = UITextField()
    private let errorLabel = UILabel().setFont(.description)
    let completeButton = CustomButton()
    var imageIndex: Int? {
        didSet { updateProfileImage() }
    }

    override func configureHierarchy() {
        [imageView, textField, errorLabel, completeButton, cameraImage].forEach { addSubview($0) }
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
//            $0.centerX.equalToSuperview()
        }
        errorLabel.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(16)
            $0.leading.equalTo(textField).inset(12)
        }
        completeButton.snp.makeConstraints {
            $0.top.equalTo(errorLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        cameraImage.snp.makeConstraints {
            $0.trailing.equalTo(imageView)
            $0.bottom.equalTo(imageView)
        }

    }
    override func configureView() {
        imageView.backgroundColor = UIColor.customBlack
        imageView.didImageSelected(isHighlighted: true)
        textField.placeholder = "닉네임을 입력해주세요"
        completeButton.setTitle("완료", for: .normal)
        cameraImage.image = UIImage(systemName: "camera.circle.fill")
        cameraImage.tintColor = UIColor.customBlue

        // userDefaults 없을 때 호출
        getRandomImage()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        print(#function)
        textField.underlined(viewSize: textField.frame.width, color: UIColor.customGray)

    }
}

// MARK: method
extension ProfileView {
    /// userDefaults에 프로필 이미지 설정이 없을 때 랜덤으로 보여주기
    private func getRandomImage() {
        self.imageIndex = (0...11).randomElement()!
        imageView.image = UIImage(named: "profile_\(imageIndex ?? 0)")
    }
    private func updateProfileImage() {
        guard let index = imageIndex else { return }
        imageView.image = UIImage(named: "profile_\(index)")
    }
}
