//
//  UIViewController+Ext.swift
//  Marvel-App
//
//  Created by YILDIRIM on 10.02.2023.
//

import UIKit
import SafariServices

extension UIViewController {
    
    func presentAlertWithError(message: UserFriendlyError, callback: @escaping(Bool) -> Void){
        DispatchQueue.main.async {
        let alert = UIAlertController(title: message.title, message: message.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Report", style: .default,handler: { _ in callback(true) }))
        alert.addAction(UIAlertAction(title: "Ok", style: .default,handler: { _ in callback(false) }))
         self.present(alert, animated: true) }
    }
    func presentAlertWithStateChange(message: StateChangeMessage, callback: @escaping (Bool) -> ()) {
        DispatchQueue.main.async {
        let alert = UIAlertController(title: message.title, message: message.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in callback(true) })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in callback(false) }))
         self.present(alert, animated: true) }
    }
    
    func presentSafariVC(with url:URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}
