import UIKit
import SnapKit

final class ProfileView: BaseView {
    let imageView = ProfileImage(frame: CGRect())
    private let cameraImage = UIImageView()
    private let textField = UITextField()
    private let errorLabel = UILabel().setFont(.description)
    let completeButton = CustomButton()

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
            $0.centerX.equalToSuperview()
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
        imageView.backgroundColor = .red
        textField.placeholder = "닉네임을 입력해주세요"
        completeButton.setTitle("완료", for: .normal)
        cameraImage.image = UIImage(systemName: "camera.circle.fill")
        cameraImage.tintColor = UIColor.customBlue
    }
}
