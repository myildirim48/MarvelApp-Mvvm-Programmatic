//
//  BasicCell.swift
//  Marvel-App
//
//  Created by YILDIRIM on 14.02.2023.
//

import UIKit
class BasicCell: UICollectionViewCell {
    
    let charImageView = ImageView(frame: .zero)
    let charNameLabel = TitleLabel(textAligment: .center, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(charNameLabel,charImageView)
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            charImageView.topAnchor.constraint(equalTo: topAnchor,constant: padding),
            charImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -padding),
            charImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: padding),
            
            charNameLabel.topAnchor.constraint(equalTo: charImageView.bottomAnchor,constant: padding),
            charNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: padding),
            charNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -padding),
            charNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -padding),
            charNameLabel.heightAnchor.constraint(equalToConstant: padding*3)
        
        ])
    }
}
