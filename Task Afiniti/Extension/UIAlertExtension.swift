//
//  UIAlertExtension.swift
//  Task Afiniti
//
//  Created by Muhammad Danish Qureshi on 5/12/21.
//

import Foundation
import UIKit
extension  UIAlertController {
    static func showAlert(title: String, message: String, actions: [UIAlertAction], in viewController: UIViewController, preferredStyle: UIAlertController.Style = .alert) {
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        for action in actions where action.title != "" {
            alertController.addAction(action)
        }
        viewController.present(alertController, animated: true, completion: nil)
    }
}
