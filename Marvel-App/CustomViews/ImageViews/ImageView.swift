//
//  ImageView.swift
//  Marvel-App
//
//  Created by YILDIRIM on 9.02.2023.
//

import UIKit
class ImageView: UIImageView {
    let placeHolderImage = Images.placeHolderHeroImage
    
    let cache = ImageFetcher.shared.imgCache
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {

        clipsToBounds = true
        contentMode = .scaleToFill
        image = placeHolderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    fileprivate let blacklisIdentifiers: [String] = [
        "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available",
        "http://i.annihil.us/u/prod/marvel/i/mg/f/60/4c002e0305708"
    ]
    
    func downloadImage(fromUrl url: String,placeHolderImage:UIImage = Images.placeHolderHeroImage!) {
        //Here is adds .jpg and http's' for security url
        if blacklisIdentifiers.contains(url){
            image = placeHolderImage
            contentMode = .center
        } else {
            var newUrls = url + ".jpg"
            let i = newUrls.index(newUrls.startIndex, offsetBy: 4)
            newUrls.insert("s", at: i)
            
            Task {
                image = await ImageFetcher.shared.downloadImage(from: newUrls) ?? placeHolderImage
            }
            return
        }
      
    }
}
