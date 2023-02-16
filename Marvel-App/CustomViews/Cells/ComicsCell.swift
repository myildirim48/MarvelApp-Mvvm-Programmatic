//
//  ComicsCell.swift
//  Marvel-App
//
//  Created by YILDIRIM on 14.02.2023.
//

import UIKit

class ComicsCell: BasicCell {

   static let reuseID = "ComicsCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setforComics(comic: ComicsResult){
        charNameLabel.text = comic.title
        charImageView.downloadImage(fromUrl: comic.thumbnail.path)
    }
}
