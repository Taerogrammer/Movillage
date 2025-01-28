import UIKit

extension UIAlertController {
    static func setDefaultAlert(title: String, message: String) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
}
