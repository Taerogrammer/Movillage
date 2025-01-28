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
        // window - 첫번째 UIWindow를 가져올 수 있는 지
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else { return }

        window.rootViewController = UINavigationController(rootViewController: TabBarController())
        window.makeKeyAndVisible()

        let vc = TabBarController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func imageTapped() {
        let vc = ProfileImageViewController()
        vc.imageIndex = profileView.imageIndex
        navigationController?.pushViewController(vc, animated: true)
    }
}
