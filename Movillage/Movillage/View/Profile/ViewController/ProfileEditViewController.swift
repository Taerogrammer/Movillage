import UIKit

final class ProfileEditViewController: UIViewController {
    private let profileEditView = ProfileEditView()

    override func loadView() {
        view = profileEditView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        [configureNavigation(), configureGesture(), bindData()].forEach { $0 }
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
        profileEditView.viewModel.input.nicknameText.value = profileEditView.profileView.textField.text
        profileEditView.viewModel.input.saveButtonTapped.value = ()
        dismiss(animated: true)
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
        setEmptyTitleBackButton()

        vc.viewModel.input.imageIndex.value = profileEditView.viewModel.output.imageIndex.value

        // TODO: 로직 분리 확인
        vc.contents = { [weak self] idx in
            self?.profileEditView.viewModel.input.imageIndex.value = idx
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: configure notification
extension ProfileEditViewController: NotificationConfiguration {
    func configureNotification() { NotificationCenter.default.post(name: NSNotification.Name("updateProfile"), object: nil) }
}

// MARK: - bind
extension ProfileEditViewController {
    private func bindData() {
        profileEditView.viewModel.output.imageName.bind { [weak self] name in
            self?.profileEditView.profileView.imageView.image = UIImage(named: name ?? "profile_0")
        }
        profileEditView.viewModel.output.imageIndex.bind { [weak self] idx in
            self?.profileEditView.imageIndex = idx
        }
        profileEditView.profileView.viewModel.output.textField.bind { [weak self] nickname in
            self?.profileEditView.profileView.textField.text = nickname
        }
        profileEditView.profileView.viewModel.output.resultText.bind { [weak self] result in
            self?.profileEditView.profileView.textInfoLabel.text = result
        }
    }
}
