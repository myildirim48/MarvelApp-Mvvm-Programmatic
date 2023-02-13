//
//  MainViewCell.swift
//  Marvel-App
//
//  Created by YILDIRIM on 9.02.2023.
//

import UIKit

class MainViewCell: UICollectionViewCell {
    
    static let reuseID = "MainViewCell"
    let charImageView = ImageView(frame: .zero)
    let charNameLabel = TitleLabel(textAligment: .center, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(character: CharacterModel){
        charNameLabel.text = character.name
        charImageView.downloadImage(fromUrl: character.thumbnail.path)
    }
    
    private func configure() {
        addSubviews(charNameLabel,charImageView)
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            charImageView.topAnchor.constraint(equalTo: topAnchor,constant: padding),
            charImageView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -padding),
            charImageView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: padding),
            charImageView.heightAnchor.constraint(equalTo: charImageView.widthAnchor),
            
            charNameLabel.topAnchor.constraint(equalTo: charImageView.bottomAnchor,constant: padding),
            charNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: padding),
            charNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -padding),
            charNameLabel.heightAnchor.constraint(equalToConstant: padding*3)
        
        ])
    }
}
