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
        navigationItem.backBarButtonItem?.title = ""
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
        print(#function)
    }
    @objc private func imageTapped() {
        let vc = ProfileImageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
