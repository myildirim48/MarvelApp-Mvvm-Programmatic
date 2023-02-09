//
//  MainVC.swift
//  Marvel-App
//
//  Created by YILDIRIM on 8.02.2023.
//

import UIKit

fileprivate typealias CharDataSource = UICollectionViewDiffableDataSource<MainVC.Section,CharResult>

class MainVC: LoadingVC {
    
    private var characters : [CharResult] = []
    private var filteredCharacters : [CharResult] = []
    
    private var pageNum = 1
    private var hasMoreData = true
    private var isSearching = false
    private var isLoadingMoreData = false
    
    private var collectionView : UICollectionView!
    private var dataSource : CharDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        Task {
            let data = try await NetworkManager.shared.getDataGeneric(for: EndPoints.charactersUrl(page: 1), data: GameDetail.self)
            print(data)
        }
    }
    
    private func configureCollectionView(){
        
    }
}

extension MainVC {
    fileprivate enum Section {
        case character
    }
}


