import Foundation
import UIKit

struct ConfirmationAlert {

    func show(on viewController: UIViewController, title: String, message: String, yesText: String,
              noText: String, yesAction: @escaping () -> Void, noAction: @escaping () -> Void) {

        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)

        alertController.addAction(
            UIAlertAction(title: noText, style: .default, handler: { action in
                noAction()
        }))

        alertController.addAction(
            UIAlertAction(title: yesText, style: .default, handler: { action in
                yesAction()
        }))

        viewController.present(alertController, animated: true, completion: nil)
    }
}
