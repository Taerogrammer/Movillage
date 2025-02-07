import UIKit

final class ProfileViewController: UIViewController {
    private let profileView = ProfileView()

    override func loadView() {
        view = profileView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        [configureButton(), configureNavigation(), configureGesture(), bindData()].forEach { $0 }
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
        print(#function)
//        guard let nickname = profileView.textField.text else { return }
//        UserDefaultsManager.nickname = nickname
//        guard let index = profileView.imageIndex else { return }
//        UserDefaultsManager.profileImage = "profile_\(index)"
//        UserDefaultsManager.registerDate = getRegisterDate()
//        UserDefaultsManager.didStart.toggle()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else { return }

        window.rootViewController = TabBarController()
        window.makeKeyAndVisible()
    }
    @objc private func imageTapped() {
        let vc = ProfileImageViewController()
        vc.viewModel.inputImageIndex.value = profileView.viewModel.outputImageIndex.value

        // TODO: 로직 분리 확인
        vc.contents = { [weak self] idx in
            self?.profileView.viewModel.inputImageIndex.value = idx
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: method
extension ProfileViewController {
    /// dateFormatter의 인스턴스 생성이 상대적으로 무겁지만,
    /// 완료 버튼이 눌릴 때에만 실행되기 때문에 타입 프로퍼티로 관리하여 데이터 영역에 저장해두기보단
    /// 스택 영역에서 실행하고자 하였습니다.
    private func getRegisterDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        return formatter.string(from: Date())
    }
}

// MARK: - bind
extension ProfileViewController {
    private func bindData() {
        profileView.viewModel.outputImageName.bind { [weak self] name in
            self?.profileView.imageView.image = UIImage(named: name)
        }
        profileView.viewModel.outputResultText.lazyBind { [weak self] text in
            self?.profileView.textInfoLabel.text = text
        }
        profileView.viewModel.buttonIsEnabled.lazyBind { [weak self] enabled in
            self?.profileView.completeButton.isEnabled = enabled
        }
    }
}
