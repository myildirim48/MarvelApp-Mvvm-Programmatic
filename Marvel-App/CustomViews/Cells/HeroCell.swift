//
//  MainViewCell.swift
//  Marvel-App
//
//  Created by YILDIRIM on 9.02.2023.
//

import UIKit

class HeroCell: UICollectionViewCell {
    
    static let reuseID = "hero-cell-identifier"

    let imageView = UIImageView()
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    @objc let favoritesButton = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func favoriteButtonTapped(_ sender: UIButton){
        
    }

    //MARK: -Private
    private func configure(){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        favoritesButton.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = Theme.colors.imageViewBackgroundColor
        imageView.layer.cornerRadius = 46.0
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor.systemGray3.cgColor
        
        favoritesButton.addTarget(self, action: #selector(self.favoriteButtonTapped(_:)), for: .touchUpInside)
        favoritesButton.setImage(UIImage(systemName: "star"), for: .normal)
        favoritesButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
        favoritesButton.tintColor = .systemOrange
        favoritesButton.contentVerticalAlignment = .fill
        favoritesButton.contentHorizontalAlignment = .fill
        
        nameLabel.font = Theme.fonts.titleFont
        nameLabel.numberOfLines = 1
        nameLabel.textAlignment = .left
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.textAlignment = .left
        descriptionLabel.lineBreakMode = .byTruncatingTail
        descriptionLabel.font = Theme.fonts.desriptionFont
        
        addSubviews(imageView,nameLabel,favoritesButton,descriptionLabel)
        
        backgroundColor = .systemGray5
        layer.cornerRadius = 16.0
        
        let outerSpacing = CGFloat(20)
        let innerSpacing = CGFloat(10)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor,constant: outerSpacing),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: outerSpacing),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -outerSpacing),
            nameLabel.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: -innerSpacing),
            
            imageView.topAnchor.constraint(equalTo: descriptionLabel.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -outerSpacing),
            imageView.widthAnchor.constraint(equalToConstant: 92.0),
            imageView.heightAnchor.constraint(equalToConstant: 92.0),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: innerSpacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: outerSpacing),
            descriptionLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor,constant: -innerSpacing),
            descriptionLabel.bottomAnchor.constraint(equalTo: favoritesButton.topAnchor,constant: -innerSpacing),
            
            favoritesButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,constant: -innerSpacing),
            favoritesButton.leadingAnchor.constraint(equalTo: leadingAnchor,constant: outerSpacing),
            favoritesButton.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -outerSpacing),
            favoritesButton.widthAnchor.constraint(equalToConstant: 30),
            favoritesButton.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        
    }

}
