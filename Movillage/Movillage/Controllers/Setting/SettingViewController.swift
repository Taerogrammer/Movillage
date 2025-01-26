import UIKit

final class SettingViewController: UIViewController {

    private let settingView = SettingView()
    private let tableViewData: [String] = ["자주 묻는 질문", "1:1 문의", "알림 설정", "탈퇴하기"]

    override func loadView() {
        view = settingView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        [configureNavigation(), configureDelegate()].forEach { $0 }
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
        cell.label.text = tableViewData[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 3 { withdrawTapped() }
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
    private func withdrawTapped() {
        print(#function)
    }
}
