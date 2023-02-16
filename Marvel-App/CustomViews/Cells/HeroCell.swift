//
//  MainViewCell.swift
//  Marvel-App
//
//  Created by YILDIRIM on 9.02.2023.
//

import UIKit

class HeroCell: UICollectionViewCell {
    
    static let reuseID = "hero-cell-identifier"

    let imageView = ImageView(frame: .zero)
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    let favoritesButton = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func favoriteButtonTapped(_ sender: UIButton){
        
    }
    var character: CharacterModel? {
        didSet {
            update()
        }
    }
    
    private func update() {
        guard let character = character else {
            nameLabel.text = nil
            descriptionLabel.text = nil
            return
        }

        nameLabel.text = character.name
        descriptionLabel.text = character.description.isEmpty ? unavailableDescription : character.description
        imageView.downloadImage(fromUrl: character.thumbnail.path)
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
        
        descriptionLabel.numberOfLines = 4
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
            nameLabel.topAnchor.constraint(equalTo: topAnchor,constant: innerSpacing),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: outerSpacing),
            nameLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -outerSpacing),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            imageView.topAnchor.constraint(equalTo: nameLabel.topAnchor,constant: innerSpacing),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -outerSpacing),
            imageView.widthAnchor.constraint(equalToConstant: 105),
            imageView.heightAnchor.constraint(equalToConstant: 105),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: innerSpacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: outerSpacing),
            descriptionLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor,constant: -innerSpacing),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: favoritesButton.topAnchor, constant: -outerSpacing ),
            
            favoritesButton.leadingAnchor.constraint(equalTo: leadingAnchor,constant: outerSpacing),
            favoritesButton.widthAnchor.constraint(equalToConstant: 30),
            favoritesButton.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

}
