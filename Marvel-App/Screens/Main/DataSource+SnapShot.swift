//
//  DataSource+SnapShot.swift
//  Marvel-App
//
//  Created by YILDIRIM on 20.02.2023.
//

import UIKit

typealias HeroSnapShot = NSDiffableDataSourceSnapshot<HeroDataSource.Section, Characters>

class HeroDataSource: UICollectionViewDiffableDataSource<HeroDataSource.Section, Characters> {
    
    enum Section {
        case main
    }
}

typealias ResourceSnapshot = NSDiffableDataSourceSnapshot<ResourceDataSource.Section, DisplayableResource>

class ResourceDataSource: UICollectionViewDiffableDataSource<ResourceDataSource.Section, DisplayableResource> {
    enum Section:CaseIterable {
    case comics, stories, events, series
    }
}
