//
//  DataSource+SnapShot.swift
//  Marvel-App
//
//  Created by YILDIRIM on 20.02.2023.
//

import UIKit

typealias MainSnapShot = NSDiffableDataSourceSnapshot<MainDataSource.Section, Characters>

class MainDataSource: UICollectionViewDiffableDataSource<MainDataSource.Section, Characters> {
    
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
