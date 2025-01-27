import UIKit

final class ProfileImageViewController: UIViewController {
    let profileImageView = ProfileImageView()

    override func loadView() {
        view = profileImageView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
    }
}

// MARK: configure navigation
extension ProfileImageViewController: NavigationConfiguration {
    func configureNavigation() {
        title = "프로필 이미지 편집"
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = UIColor.customBlue
        navigationItem.leftBarButtonItem = backButton
    }
}

// MARK: @objc
extension ProfileImageViewController {
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
