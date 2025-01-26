import UIKit

final class ProfileImageViewController: UIViewController {
    private let profileImageView = ProfileImageView()

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
    }
}
