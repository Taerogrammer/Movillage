import UIKit

final class ProfileViewController: UIViewController {
    private let profileView = ProfileView()

    override func loadView() {
        view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        [configureButton(), configureNavigation(), configureGesture()].forEach { $0 }
    }
}

// MARK: configure button
extension ProfileViewController: ButtonConfiguration {
    func configureButton() {
        profileView.completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
}

// MARK: configure navigation
extension ProfileViewController: NavigationConfiguration {
    func configureNavigation() {
        navigationItem.title = "프로필 설정"
        setEmptyTitleBackButton()
    }

}

// MARK: configure etc
extension ProfileViewController {
    private func configureGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileView.imageView.isUserInteractionEnabled = true
        profileView.imageView.addGestureRecognizer(tapGesture)
    }
}

// MARK: @objc
extension ProfileViewController {
    @objc private func completeButtonTapped() {
        guard let index = profileView.imageIndex else { return }
        UserDefaultsManager.profileImage = "profile_\(index)"
        UserDefaultsManager.didStart.toggle()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else { return }

        window.rootViewController = UINavigationController(rootViewController: TabBarController())
        window.makeKeyAndVisible()
    }
    @objc private func imageTapped() {
        let vc = ProfileImageViewController()
        vc.imageIndex = profileView.imageIndex

        vc.contents = { value in
            self.profileView.imageIndex = value
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
