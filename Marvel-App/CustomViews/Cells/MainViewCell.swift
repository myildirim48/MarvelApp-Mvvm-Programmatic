//
//  MainViewCell.swift
//  Marvel-App
//
//  Created by YILDIRIM on 9.02.2023.
//

import UIKit

class MainViewCell: BasicCell {
    
    static let reuseID = "MainViewCell"

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(character: CharacterModel){
        charNameLabel.text = character.name
        charImageView.downloadImage(fromUrl: character.thumbnail.path)
    }

}
