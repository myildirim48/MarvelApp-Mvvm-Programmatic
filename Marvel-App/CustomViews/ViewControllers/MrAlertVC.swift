//
//  MrAlertVC.swift
//  Marvel-App
//
//  Created by YILDIRIM on 10.02.2023.
//

import UIKit

class MrAlertVC: UIViewController  {
    
    let containerView = AlertContainerView()
    let titleLabel = TitleLabel(textAligment: .center, fontSize: 20)
    let messageLabel = BodyLabel(textAligment: .center, font: 15)
    let actionButton = MrButton(color: .systemRed, title: "Ok", systemImageName: SFSymbols.checkMark)
    
    var alertTitle:String?
    var alertMessage:String?
    var buttonTitle:String?
    
    let padding : CGFloat = 20
    
    init(alertTitle: String? = nil, alertMessage: String? = nil, buttonTitle: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.addSubviews(containerView,titleLabel,messageLabel,actionButton)
        configureLayout()
    }
    
    private func configureLayout(){
        
        titleLabel.text = alertTitle ?? "Something went wrong"
        
        actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        actionButton.addTarget(self, action: #selector(dissmisVC), for: .touchUpInside)
        
        messageLabel.text = alertMessage ?? "Unable to complete the request"
        messageLabel.numberOfLines = 4
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 180),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor,constant: -12),
            
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc func dissmisVC(){
        dismiss(animated: true)
    }
    
}
