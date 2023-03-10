//
//  MainViewCell.swift
//  Marvel-App
//
//  Created by YILDIRIM on 9.02.2023.
//

import UIKit
protocol HeroCellDelegate:NSObject {
    func heroCellFavoriteButtonTapped(cell:HeroCell)
}

class HeroCell: UICollectionViewCell {
    
    static let reuseID = "hero-cell-identifier"

    let imageView = ImageView(frame: .zero)
    let nameLabel = MrLabel(textAligment: .left
                               , font: Theme.fonts.titleFont)
    let descriptionLabel = MrLabel(textAligment: .left, font: Theme.fonts.desriptionFont)
    let favoritesButton = FavoritesButton(frame: .zero)
    
    weak var delegate: HeroCellDelegate?
    
    @objc func favoriteButtonTapped(_ sender: UIButton){
        guard let delegate = delegate else { return }
        delegate.heroCellFavoriteButtonTapped(cell: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    

    var character: Characters? {
        didSet {
            update()
        }
    }
    
    public func update(image: UIImage?){
        DispatchQueue.main.async {
            self.update(image)
        }
    }
    
    //MARK: -Private
    
    private func update() {
        
        guard let character = character else {
            nameLabel.text = nil
            descriptionLabel.text = nil
            return
        }

        nameLabel.text = character.name
        descriptionLabel.text = character.description.isEmpty ? unavailableDescription : character.description
        guard let imgUrl = character.thumbnail?.path else { return }
        imageView.downloadImage(fromUrl: imgUrl, placeHolderImage: Images.placeHolderHeroImage)
    }
    
    private func update(_ image: UIImage?){
        guard let image = image else {
            return imageView.image = Images.placeHolderHeroImage
        }
            self.imageView.image = image
    }
    private func configure(){
        
        imageView.backgroundColor = Theme.colors.imageViewBackgroundColor
        imageView.layer.cornerRadius = 46.0
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor.systemGray3.cgColor
        imageView.contentMode = .scaleAspectFit
        
        favoritesButton.addTarget(self, action: #selector(self.favoriteButtonTapped(_:)), for: .touchUpInside)
        
        nameLabel.font = Theme.fonts.titleFont
        nameLabel.numberOfLines = 1
        
        descriptionLabel.numberOfLines = 3
        descriptionLabel.textColor = .secondaryLabel
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
            favoritesButton.widthAnchor.constraint(equalToConstant: 35),
            favoritesButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }

}
