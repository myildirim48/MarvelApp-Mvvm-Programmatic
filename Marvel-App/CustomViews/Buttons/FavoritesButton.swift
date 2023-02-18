//
//  FavoritesButton.swift
//  Marvel-App
//
//  Created by YILDIRIM on 18.02.2023.
//

import UIKit

class FavoritesButton : UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        setImage(UIImage(systemName: "star"), for: .normal)
        setImage(UIImage(systemName: "star.fill"), for: .selected)
        tintColor = .systemOrange
        contentVerticalAlignment = .fill
        contentHorizontalAlignment = .fill
        
    }
}
