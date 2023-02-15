//
//  Theme.swift
//  Marvel-App
//
//  Created by YILDIRIM on 15.02.2023.
//

import UIKit

struct Theme {
    struct colors {
        static let primaryColor : UIColor = .systemPurple
        static let secondaryColor : UIColor = .systemOrange
        
        static let primaryLabelColor : UIColor = .label
        static let secondaryLabelColor : UIColor = .secondaryLabel
        
        static let imageViewBackgroundColor : UIColor = .systemGray6
    }
    
    struct fonts {
        static let titleSize = CGFloat(18.0)
        static let titleWeight : UIFont.Weight = .semibold
        static let titleDescriptor = UIFont.systemFont(ofSize: titleSize, weight: titleWeight).fontDescriptor.withDesign(.rounded)
        static let titleFont: UIFont = Theme.fonts.titleDescriptor == nil ? .systemFont(ofSize: titleSize,weight: titleWeight) : UIFont(descriptor: Theme.fonts.titleDescriptor!, size: 0.0)
        static let desriptionFont = UIFont.preferredFont(forTextStyle: .caption2).withSize(14)
    }
}
