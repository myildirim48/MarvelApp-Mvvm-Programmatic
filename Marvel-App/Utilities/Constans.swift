//
//  Constans.swift
//  Marvel-App
//
//  Created by YILDIRIM on 9.02.2023.
//

import UIKit

enum Images {
    static let emptyImage = UIImage(named: "marvel-logo")
    static let placeHolderHeroImage = UIImage(named: "hero_placeholder")
    static let placeHolderResourceImage : UIImage = {
        let configuration = UIImage.SymbolConfiguration(scale: .medium)
        let image = UIImage(systemName: "person.crop.square",withConfiguration: configuration)!
        return image.withTintColor(.systemGray5, renderingMode: .alwaysOriginal).withTintColor(.systemGray3)
    }()
}

enum TabbarImgName {
    static let mainVCImage = "book.circle"
    static let favoriteVCImage = "star.circle.fill"
}

enum SFSymbols{
    static let checkMark = "checkmark.circle"
}

let unavailableDescription = "There is no description"
