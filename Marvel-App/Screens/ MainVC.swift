//
//  MainVC.swift
//  Marvel-App
//
//  Created by YILDIRIM on 8.02.2023.
//

import UIKit

enum Section: String,CaseIterable {
    case character = "Characters"
    case comics = "Comics"
}


class MainVC: LoadingVC {
    
    private var characterArr:   [CharacterModel] = []
    private var filteredCharacters : [CharacterModel] = []
    private var comicsArr: [ComicsResult] = []
    private var filteredComics: [ComicsResult] = []
    
    private var pageNumChar = 0
    private var pageNumComics = 0
    private var offset = 0
    
    private var hasMoreDataForChar = true
    private var hasMoreDataForComics = true
    
    private var isSearching = false
    private var isLoadingMoreData = false
    
    private var collectionView : UICollectionView!
    private var dataSource : UICollectionViewDiffableDataSource<Section,AnyHashable>!
    private var snapShot = NSDiffableDataSourceSnapshot<Section,AnyHashable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        getCharacters(offset: offset)
        getComics(offset: offset)
        configureDataSource()
    }
    
    private func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(HeroCell.self, forCellWithReuseIdentifier: HeroCell.reuseID)
        collectionView.register(ComicsCell.self, forCellWithReuseIdentifier: ComicsCell.reuseID)
    }
    private func configureDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            if let chars = item as? CharacterModel {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCell.reuseID, for: indexPath) as! HeroCell
//                cell.set(character: chars)
                return cell
            }else if let comics = item as? ComicsResult {
                
                let cellComic = collectionView.dequeueReusableCell(withReuseIdentifier: ComicsCell.reuseID, for: indexPath) as! ComicsCell
                cellComic.setforComics(comic: comics)
                return cellComic
            }else {
                self.presentMrAlert(title: "Unknown Cell", message: "Invalid cell type.", buttonTitle: "Ok")
                fatalError("Unknown cell type")
            }
        })
    }
    
    private func getCharacters(offset: Int){
        if loadingContainerView == nil { showLoadingView() }
        isLoadingMoreData = true
        Task{
            do {
                let charFromApi = try await NetworkManager.shared.getDataGeneric(for: EndPoints.charactersUrl(offset: offset), data: CharacterResponse.self)
                updateUI(charResult: charFromApi, comics: nil)
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
    
    private func getComics(offset: Int){
        if loadingContainerView == nil { showLoadingView() }
        isLoadingMoreData = true
        Task {
            do {
                let comicFromApi = try await NetworkManager.shared.getDataGeneric(for: EndPoints.comicsUrl(offset: offset), data: ComicsResponse.self)
                updateUI(charResult: nil, comics: comicFromApi)
                
                if loadingContainerView != nil { dissmisLoadingView() }
                isLoadingMoreData = false
            }catch{
                if let err = error as? marvelError {
                    presentMrAlert(title: "Bad stuff happened", message: err.rawValue, buttonTitle: "Ok")
                }else {
                    presentDefaultError()
                }
                if loadingContainerView != nil { dissmisLoadingView() }
            }
        }
    }
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            if sectionIndex == 0 {
                return UIHelper.layoutSection(fractionalWith: 0.5, fractionalHeight: 0.25)
            }else {
                return UIHelper.layoutSection(fractionalWith: 0.8, fractionalHeight: 0.50)
            }
        }
        return layout
    }
    
    private func updateChars(char:[CharacterModel]){
        
        snapShot.appendSections([.character])
        snapShot.appendItems(char, toSection: .character)
        DispatchQueue.main.async {
            self.dataSource.apply(self.snapShot, animatingDifferences: true)
        }
    }
    
    private func updateComics(comics:[ComicsResult]){
        
        if snapShot.numberOfSections >= 2 {
            DispatchQueue.main.async {
                self.dataSource.apply(self.snapShot, animatingDifferences: true)
            }
        }else {
            
            snapShot.appendSections([.comics])
            snapShot.appendItems(comics,toSection: .comics)
            DispatchQueue.main.async {
                self.dataSource.apply(self.snapShot, animatingDifferences: true)
            }
        }

    }
    
    private func updateUI(charResult: CharacterResponse?, comics: ComicsResponse?){
        
        if let char = charResult {
            if characterArr.count == char.data.total { self.hasMoreDataForChar = false } //For pagination
            self.characterArr.append(contentsOf: char.data.results)//For pagination
            print("Char arrcount : ", characterArr.count)
            updateChars(char: char.data.results)
            
        }
        if let comic = comics {
            if comicsArr.count == comic.data.total { self.hasMoreDataForComics = false }
            self.comicsArr.append(contentsOf: comic.data.results)
            print("ComicsArr count: ", comicsArr.count)
            updateComics(comics: comic.data.results)
        }
        
        
    }
}

extension MainVC:UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.item >= characterArr.count - 2  {
            guard hasMoreDataForChar,!isLoadingMoreData else { return }
            pageNumChar += 1
            offset = pageNumChar * 20
            getCharacters(offset: offset)
        }
        if indexPath.item >= comicsArr.count - 2 {
            guard hasMoreDataForComics, !isLoadingMoreData else { return }
            pageNumComics += 1
            offset = pageNumComics * 20
            getComics(offset: offset)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO
    }
}


