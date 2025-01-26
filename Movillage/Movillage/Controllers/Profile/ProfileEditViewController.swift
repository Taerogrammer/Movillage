import UIKit

final class ProfileEditViewController: UIViewController {

    private let profileEditView = ProfileEditView()

    override func loadView() {
        view = profileEditView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        [configureNavigation(), configureGesture()].forEach { $0 }
    }
}

// MARK: configure navigation
extension ProfileEditViewController: NavigationConfiguration {
    func configureNavigation() {
        title = "프로필 편집"
        let closeButton = UIBarButtonItem(image: UIImage(systemName:"xmark"), style: .plain, target: self, action: #selector(closeButtonTapped))
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
        closeButton.tintColor = UIColor.customBlue
        saveButton.tintColor = UIColor.customBlue
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = saveButton
    }
}

// MARK: @objc
extension ProfileEditViewController {
    @objc private func closeButtonTapped() { dismiss(animated: true) }
    @objc private func saveButtonTapped() {
        print(#function)
    }
}

// MARK: configure etc
extension ProfileEditViewController {
    private func configureGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileEditView.profileView.imageView.isUserInteractionEnabled = true
        profileEditView.profileView.imageView.addGestureRecognizer(tapGesture)
    }
}

// MARK: @objc
extension ProfileEditViewController {
    @objc private func imageTapped() {
        let vc = ProfileImageViewController()
        present(vc, animated: true)
    }
}
