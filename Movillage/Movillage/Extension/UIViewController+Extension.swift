import UIKit


extension UIViewController {
    /// 뒤로가기 버튼
    func setEmptyTitleBackButton() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backButton.tintColor = UIColor.customBlue
        navigationItem.backBarButtonItem = backButton
    }

    /// UserDefaults에서 좋아요 클릭 시
    static func didFavoriteTapped(id: Int) {
        UserDefaultsManager.favoriteMovie.contains(id) ?
        UserDefaultsManager.favoriteMovie.removeAll(where: { $0 == id })
        : UserDefaultsManager.favoriteMovie.append(id)
    }

    /// 네트워크 에러 호출
    func networkErrorAlert(error: Error) {
        if let networkError = error as? NetworkError {
            let alert = UIAlertController.setDefaultAlert(title: "오류", message: networkError.errorMessage)
            let okay = UIAlertAction(title: "확인", style: .cancel)
            alert.addAction(okay)
            present(alert, animated: true)
        }
    }
}
