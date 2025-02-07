import UIKit
import SnapKit

final class ProfileCardView: BaseView {
    let profileImage = ProfileImage(frame: CGRect())
    let nicknameLabel = UILabel().setFont(.header)
    private let registerLabel = UILabel().setFont(.description)
    let likeCountButton = UIButton()
    private let chevronImage = UIImageView()

    override func configureHierarchy() {
        [profileImage, nicknameLabel, registerLabel, likeCountButton, chevronImage].forEach { addSubview($0) }
    }
    override func configureLayout() {
        profileImage.snp.makeConstraints {
            $0.leading.top.equalTo(self.safeAreaLayoutGuide).inset(12)
            $0.width.height.equalTo(60)
        }
        nicknameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImage.snp.trailing).offset(12)
            $0.bottom.equalTo(profileImage.snp.centerY).offset(-2)
        }
        registerLabel.snp.makeConstraints {
            $0.leading.equalTo(nicknameLabel)
            $0.top.equalTo(profileImage.snp.centerY).offset(2)
        }
        chevronImage.snp.makeConstraints {
            $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(12)
            $0.centerY.equalTo(profileImage)
        }
        likeCountButton.snp.makeConstraints {
            $0.leading.equalTo(profileImage)
            $0.top.equalTo(profileImage.snp.bottom).offset(12)
            $0.trailing.bottom.equalTo(self.safeAreaLayoutGuide).inset(12)
            $0.height.lessThanOrEqualTo(40)
        }
    }
    override func configureView() {
        clipsToBounds = true
        backgroundColor = UIColor.customGray
        layer.cornerRadius = 12
        profileImage.image = UIImage(named: UserDefaultsManager.profileImage ?? "profile_0")
        profileImage.isEnabledOrHighlighted(isHighlighted: true)
        nicknameLabel.text = UserDefaultsManager.nickname
        registerLabel.text = "\(UserDefaultsManager.registerDate ?? Date().description) 가입"
        registerLabel.textColor = UIColor.customWhiteGray
        chevronImage.image = UIImage(systemName: "chevron.right")
        chevronImage.tintColor = UIColor.customWhiteGray
        likeCountButton.setTitle("\(UserDefaultsManager.favoriteMovie.count)개의 무비박스 보관중", for: .normal)
        likeCountButton.clipsToBounds = true
        likeCountButton.backgroundColor = UIColor.customBlue
        likeCountButton.layer.cornerRadius = 8
        likeCountButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        likeCountButton.titleLabel?.textColor = UIColor.customWhite
        likeCountButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        isUserInteractionEnabled = true
    }
}
