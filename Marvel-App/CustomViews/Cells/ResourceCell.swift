//
//  ResourceCell.swift
//  Marvel-App
//
//  Created by YILDIRIM on 22.02.2023.
//

import UIKit

class ResourceCell: UICollectionViewCell {
    static let reuseIdentifier = "resource-cell-reuse-identifier"
    var representedIdentifier: String?
    
    let imageView = ImageView(frame: .zero)
    let titleLabel = MrLabel(textAligment: .left, font: Theme.fonts.desriptionFont)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
}

extension ResourceCell {
    func configure(){
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        titleLabel.adjustsFontForContentSizeCategory = true
        
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = Theme.colors.imageViewBackgroundColor

        let spacing = CGFloat(10)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: spacing),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 10.0)
        ])
    }
}
