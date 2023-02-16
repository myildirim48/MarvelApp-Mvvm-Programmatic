//
//  MainVC.swift
//  Marvel-App
//
//  Created by YILDIRIM on 8.02.2023.
//

import UIKit

enum Section {
    case main
}


class MainVC: LoadingVC {
    
    private var characterArr:   [CharacterModel] = []
    private var filteredCharacters : [CharacterModel] = []
    
    private var pageNumChar = 0
    private var offset = 0
    
    private var hasMoreDataForChar = true
    private var hasMoreDataForComics = true
    
    private var isSearching = false
    private var isLoadingMoreData = false
    
    private var collectionView : UICollectionView!
    private var dataSource : UICollectionViewDiffableDataSource<Section,CharacterModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        getCharacters(offset: offset)
        configureDataSource()
    }
    
    private func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.layoutSection(fractionalWith: 1.0, fractionalHeight: 0.25))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(HeroCell.self, forCellWithReuseIdentifier: HeroCell.reuseID)
    }
    private func configureDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Section, CharacterModel>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCell.reuseID, for: indexPath) as! HeroCell
            cell.character = item
            return cell
            
        })
    }
    
    private func getCharacters(offset: Int){
        if loadingContainerView == nil { showLoadingView() }
        isLoadingMoreData = true
        Task{
            do {
                let charFromApi = try await NetworkManager.shared.getDataGeneric(for: EndPoints.charactersUrl(offset: offset), data: CharacterResponse.self)
                updateUI(char: charFromApi)
                if loadingContainerView != nil { dissmisLoadingView() }
                isLoadingMoreData = false
            }catch{
                if let err = error as? marvelError{
                    presentMrAlert(title: "Bad stuff happend", message: err.rawValue, buttonTitle: "Ok")
                }else {
                    presentDefaultError()
                }
                if loadingContainerView != nil { dissmisLoadingView() }
            }
        }
    }
    
//    private func createLayout() -> UICollectionViewCompositionalLayout {
//        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
//            if sectionIndex == 0 {
//                return UIHelper.layoutSection(fractionalWith: 0.5, fractionalHeight: 0.25)
//            }else {
//                return UIHelper.layoutSection(fractionalWith: 0.8, fractionalHeight: 0.50)
//            }
//        }
//        return layout
//    }
    
    private func updateChars(char:[CharacterModel]){
        var snapShot = NSDiffableDataSourceSnapshot<Section,CharacterModel>()
        snapShot.appendSections([.main])
        snapShot.appendItems(char)
        DispatchQueue.main.async {
            self.dataSource.apply(snapShot, animatingDifferences: true)
        }
    }
    
    private func updateUI(char: CharacterResponse){
        if characterArr.count == char.data.total { self.hasMoreDataForChar = false } //For pagination
        self.characterArr.append(contentsOf: char.data.results)//For pagination
        updateChars(char: characterArr)
    }
}
extension MainVC:UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.item,characterArr.count)
        if indexPath.item >= characterArr.count - 4 {
            guard hasMoreDataForChar,!isLoadingMoreData else { return }
            pageNumChar += 1
            offset = pageNumChar * 20
            getCharacters(offset: offset)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO
    }
}


