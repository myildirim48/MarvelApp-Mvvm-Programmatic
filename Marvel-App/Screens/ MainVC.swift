//
//  MainVC.swift
//  Marvel-App
//
//  Created by YILDIRIM on 8.02.2023.
//

import UIKit

class MainVC: LoadingVC {
    enum Section {
        case character
    }
    
    private var characters : Characters?
    private var char:[CharResult] = []
    private var filteredCharacters : [CharResult] = []
    
    private var pageNum = 1
    private var hasMoreData = true
    private var isSearching = false
    private var isLoadingMoreData = false
    
    private var collectionView : UICollectionView!
    private var dataSource : UICollectionViewDiffableDataSource<MainVC.Section,CharResult>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        getData(page: pageNum)
    }
    
    private func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.horizontalFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: MainViewCell.reuseID)
    }
    private func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Section,CharResult>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainViewCell.reuseID, for: indexPath) as! MainViewCell
            cell.set(character: itemIdentifier)
            return cell
        })
    }
    
    private func getData(page: Int){
        showLoadingView()
        isLoadingMoreData = true
        Task{
            do {
                let data = try await NetworkManager.shared.getDataGeneric(for: EndPoints.charactersUrl(page: 1), data: Characters.self)
                updateUI(with: data)
                dissmisLoadingView()
            }catch{
                if let err = error as? marvelError{
                    presentMrAlert(title: "Bad stuff happend", message: err.rawValue, buttonTitle: "Ok")
                }else {
                    presentDefaultError()
                }
                dissmisLoadingView()
            }
        }
    }
    
    private func updateData(on charResult: [CharResult]){
        var snapShot = NSDiffableDataSourceSnapshot<Section,CharResult>()
        snapShot.appendSections([.character])
        snapShot.appendItems(charResult)
        DispatchQueue.main.async {
            self.dataSource.apply(snapShot,animatingDifferences: true)
        }
    }
    
    private func updateUI(with charResult: Characters ){
        //        if charResult.count < 50 { self.hasMoreData = false } //For pagination
        //        self.characters.append(charResult)//For pagination
        
        char = charResult.data.results
        self.updateData(on: char)
    }
}

extension MainVC:UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //        TODO
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO
    }
}


