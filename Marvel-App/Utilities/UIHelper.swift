//
//  UIHelper.swift
//  Marvel-App
//
//  Created by YILDIRIM on 10.02.2023.
//

import UIKit

enum UIHelper {
    static func horizontalFlowLayout(in view: UIView, fractionalWith:CGFloat,fractionalHeight:CGFloat) -> UICollectionViewCompositionalLayout{
        return UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension:  .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            //2
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionalWith), heightDimension: .fractionalHeight(fractionalHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize:  groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        }
    }
    
    static func layoutSection(fractionalWith:CGFloat,fractionalHeight:CGFloat) -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension:  .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        //2
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionalWith), heightDimension: .fractionalHeight(fractionalHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize:  groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        
        return UICollectionViewCompositionalLayout(section: section)
        
    }
}
