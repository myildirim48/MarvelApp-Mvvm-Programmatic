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
    //MARK: - Resources layout
    
    enum ResourceSection: Int, CaseIterable {
        case comics, stories, events, series
        
        var sectionTitle: String {
            switch self {
                case .comics: return "Comics"
                case .stories: return "Stories"
                case .events: return "Events"
                case .series: return "Series"
            }
        }
        
        func columnCount(for width: CGFloat) -> Int {
            let wideMode = width > 800
            let narrowMode = width < 420
            
            switch self {
                case .comics, .stories, .events, .series:
                    return wideMode ? 3 : narrowMode ? 1 : 2
            }
        }
        
        var groupSize: (width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension) {
            switch self {
                case .comics: return (width: .absolute(138), height: .absolute(221))
                case .events: return (width: .fractionalWidth(0.40), height: .fractionalHeight(0.18))
                case .series: return (width: .fractionalWidth(0.40), height: .fractionalHeight(0.18))
                case .stories: return (width: .fractionalWidth(0.40), height: .fractionalHeight(0.18))
            }
        }
    }
    
    static func resourcesCollectionViewLayout() -> UICollectionViewLayout {
        
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let sectionLayoutKind = ResourceSection(rawValue: sectionIndex)!
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let sectionGroupSize = sectionLayoutKind.groupSize
            let groupSize = NSCollectionLayoutSize(widthDimension: sectionGroupSize.width, heightDimension: sectionGroupSize.height)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
            
            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSize, elementKind: TitleSupplementaryView.elementKind, alignment: .top)
            section.boundarySupplementaryItems = [titleSupplementary]
        
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        config.scrollDirection = .vertical
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        
        return layout
    }
}
