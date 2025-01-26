import UIKit


extension UIViewController {
    /// 뒤로가기 버튼
    func setEmptyTitleBackButton() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backButton.tintColor = UIColor.customBlue
        navigationItem.backBarButtonItem = backButton
    }
}
