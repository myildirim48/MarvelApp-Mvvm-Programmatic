//
//  SearchResuableView.swift
//  Marvel-App
//
//  Created by YILDIRIM on 21.02.2023.
//

import UIKit

class SearchResuableView: UICollectionReusableView {
    
    static let elementKind = "search-results-kind"
    static let reuseIdentifier = "loader-reusable-identifier"
    
    let label = MrLabel(textAligment: .left, font: Theme.fonts.desriptionFont)
    let containerView = UIView()
    let activityIndicator = UIActivityIndicatorView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func presentInformation(count: Int){
        let info = count > 0 ? "\(count) hereos found." : "No hereos found."
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.label.text = info
        }
   }
    func presentActivityIndicator(){
        DispatchQueue.main.async {
            self.label.text = nil
            self.activityIndicator.startAnimating()
        }
    }
    
    private func configure(){
        activityIndicator.hidesWhenStopped = true
        
        label.adjustsFontForContentSizeCategory = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubviews(label,activityIndicator)
        addSubview(containerView)
        
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: inset+5),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -inset),
            label.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
    }
}
