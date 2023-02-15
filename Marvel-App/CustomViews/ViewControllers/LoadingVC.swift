//
//  LoadingVC.swift
//  Marvel-App
//
//  Created by YILDIRIM on 9.02.2023.
//

import UIKit
class LoadingVC: UIViewController {
     var loadingContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showLoadingView() {
        loadingContainerView = UIView(frame: view.bounds)
        view.addSubview(loadingContainerView)
        
        loadingContainerView.backgroundColor = .systemBackground
        loadingContainerView.alpha = 0
        
        UIView.animate(withDuration: 0.25, delay: 0) { self.loadingContainerView.alpha = 0.8 }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        loadingContainerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: loadingContainerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: loadingContainerView.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func dissmisLoadingView(){
        DispatchQueue.main.async {
            self.loadingContainerView.removeFromSuperview()
            self.loadingContainerView = nil
        }

    }
}
