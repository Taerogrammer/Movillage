import UIKit

final class SettingViewController: UIViewController {

    private let settingView = SettingView()
    private let tableViewData: [String] = ["자주 묻는 질문", "1:1 문의", "알림 설정", "탈퇴하기"]
    // 탈퇴하기 인덱스
    private let withdrawIndex: Int = 3

    override func loadView() {
        view = settingView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        [configureNavigation(), configureDelegate(), configureProfileCard()].forEach { $0 }
    }
}

// MARK: configure navigation
extension SettingViewController: NavigationConfiguration {
    func configureNavigation() {
        navigationItem.title = "설정"
    }
}

// MARK: configure tableview
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.id, for: indexPath) as! SettingTableViewCell
        cell.configureCell(content: tableViewData[indexPath.row])
        cell.selectionStyle = (indexPath.row == withdrawIndex) ? .default : .none

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == withdrawIndex { withdrawTapped() }
    }
}

// MARK: configure delegate
extension SettingViewController: DelegateConfiguration {
    func configureDelegate() {
        settingView.tableView.delegate = self
        settingView.tableView.dataSource = self
        settingView.tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.id)
    }
}

// MARK: methods
extension SettingViewController {
    private func withdrawTapped() { present(withdrawAlertController(), animated: true) }
    private func withdrawAlertController() -> UIAlertController {
        let alert = UIAlertController.setDefaultAlert(title: "탈퇴하기", message: "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴하시겠습니까?")

        let cancelAction = UIAlertAction(title: "확인", style: .destructive) { _ in
            UserDefaultsManager.didStart.toggle()

            // 직접 선언하기
            var userDefaultsProfileImage = UserDefault<String?>(key: "profileImage", defaultValue: nil, storage: .standard)
            userDefaultsProfileImage.removeObject()
            var userDefaultsNickname = UserDefault<String?>(key: "nickname", defaultValue: nil, storage: .standard)
            userDefaultsNickname.removeObject()

            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else { return }
            window.rootViewController = UINavigationController(rootViewController: OnboardingViewController())
            window.makeKeyAndVisible()
        }
        let confirmAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)

        return alert
    }
}

// MARK: configure profile card
extension SettingViewController: ProfileCardViewGesture {
    func configureProfileCard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileCardTapped))
        settingView.profileCardView.addGestureRecognizer(tapGesture)
    }
    @objc func profileCardTapped() {
        let navVC = UINavigationController(rootViewController: ProfileEditViewController())
        if let sheet = navVC.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        present(navVC, animated: true)
    }
}
