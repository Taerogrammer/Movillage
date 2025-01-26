import UIKit

extension UILabel {

    /// UILabel 선언 시 font를 바로 설정할 수 있도록 지정하는 메서드
    func setFont(_ font: UIFont) -> UILabel {
        self.font = font

        return self
    }
}
