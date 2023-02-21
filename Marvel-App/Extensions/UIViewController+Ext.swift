//
//  UIViewController+Ext.swift
//  Marvel-App
//
//  Created by YILDIRIM on 10.02.2023.
//

import UIKit
import SafariServices

extension UIViewController {
    
    func presentMrAlert(title: String, message: String, buttonTitle: String){
            let alertVC = MrAlertVC(alertTitle: title, alertMessage: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
    }
    
    func presentDefaultError(){
            let alertVC = MrAlertVC(alertTitle: "Something went wrong.",
                                    alertMessage: "We were unable to complete your task at this time. Please try again.",
                                    buttonTitle: "Ok")
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
    }
    
    func presentSafariVC(with url:URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}
