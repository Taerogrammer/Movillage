import UIKit

extension UITextField {
    func underlined(viewSize: CGFloat, color: UIColor) {
        layoutIfNeeded()
        let border = CALayer()
        let width = CGFloat(1)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.height + 20, width: viewSize, height: width)
        border.borderWidth = width
        self.layer.addSublayer(border)
    }
}
