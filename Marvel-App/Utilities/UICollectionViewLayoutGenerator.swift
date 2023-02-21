//
//  UICollectionViewLayoutGenerator.swift
//  Marvel-App
//
//  Created by YILDIRIM on 20.02.2023.
//

import UIKit

struct UICollectionViewLayoutGenerator {
    enum CollectionViewStyle{
    case paginated, search, favorites
        
        var suplementaryViewKindForStyle: String {
            switch self {
            case .paginated:
                return LoaderReusableView.elementKind
            case .search:
                return SearchResuableView.elementKind
            case .favorites:
                return ""
            }
        }
        
        var heightForViewKind: CGFloat {
            switch self {
            case .paginated:
                return CGFloat(60.0)
            case .search:
                return CGFloat(35.0)
            case .favorites:
                return CGFloat(43.0)
            }
        }
        
        var alignForViewKind: NSRectAlignment {
            switch self {
            case .paginated:
                return .bottom
            case .search:
                return .top
            case .favorites:
                return .none
            }
        }

    }
    
    enum SectionLayoutKind: Int,CaseIterable {
        case list
        
        func columnCount(for width: CGFloat) -> Int{
            let wideMode = width > 800
            let narrowMode = width < 420
            
            switch self {
            case .list :
                return wideMode ? 3 : narrowMode ? 1 : 2
            }
        }
    }
    
    static func generateLayoutForStyle(_ style: CollectionViewStyle) -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let sectionLayoutKind = SectionLayoutKind(rawValue: sectionIndex)!
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let itemInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            item.contentInsets = itemInsets
            
            let columns = sectionLayoutKind.columnCount(for: layoutEnvironment.container.effectiveContentSize.width)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(180))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
            
            if style != .favorites {
                let suplemantaryItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(style.heightForViewKind))
                let suplemantaryItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: suplemantaryItemSize, elementKind: style.suplementaryViewKindForStyle, alignment: style.alignForViewKind)
                section.boundarySupplementaryItems = [suplemantaryItem]
            }
            
            return section
        }
    }
}
