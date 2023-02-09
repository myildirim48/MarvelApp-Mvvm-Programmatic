//
//  ImageView.swift
//  Marvel-App
//
//  Created by YILDIRIM on 9.02.2023.
//

import UIKit
class ImageView: UIImageView {
    let placeHolderImage = Images.emptyImage
    
    let cache = NetworkManager.shared.imgCache
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeHolderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(fromUrl url:String) {
        Task {
            image = await NetworkManager.shared.downloadImage(from:url) ?? placeHolderImage
        }
    }
}
