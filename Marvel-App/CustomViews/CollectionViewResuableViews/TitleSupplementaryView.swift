//
//  TitleSupplementaryView.swift
//  Marvel-App
//
//  Created by YILDIRIM on 22.02.2023.
//

import UIKit

class TitleSupplementaryView : UICollectionReusableView {
    
    static let elementKind = "title-reusable-kind"
    static let reuseIdentifier = "title-reuse-identifier"

    let label = MrLabel(textAligment: .left, font: Theme.fonts.titleFont)

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
}
extension TitleSupplementaryView {
    func configure() {
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            label.topAnchor.constraint(equalTo: topAnchor, constant: inset)
        ])
    }
}
