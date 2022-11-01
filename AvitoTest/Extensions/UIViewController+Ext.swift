//
//  UIViewController+Ext.swift
//  AvitoTest
//
//  Created by Mikhail Kostylev on 30.10.2022.
//

import UIKit

extension UIViewController {
    func presentAlert(
        title: String,
        message: String? = nil,
        buttonTitle: String,
        style: UIAlertController.Style,
        handler: ((UIAlertAction) -> Void)? = nil
    ) {
        var alertStyle = style
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertStyle = .alert
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        let action = UIAlertAction(title: buttonTitle, style: .cancel, handler: handler)
        
        alert.addAction(action)
        present(alert, animated: true)
    }
}
