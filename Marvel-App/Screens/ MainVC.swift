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
                                 
    private var pageNum = 0
    private var offset = 0
    
    private var hasMoreDataForChar = true
    private var hasMoreDataForComics = true
    
    private var isSearching = false
    private var isLoadingMoreData = false
    
    private var collectionView : UICollectionView!
    private var dataSource : UICollectionViewDiffableDataSource<Section,AnyHashable>!
    
    private var fractionalWidth: CGFloat = 0.50
    private var fractionalHeight: CGFloat = 0.25
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        getCharacters(offset: offset)
        getComics(offset: offset)
        
    }

    private func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: MainViewCell.reuseID)
        collectionView.register(ComicsCell.self, forCellWithReuseIdentifier: ComicsCell.reuseID)
    }
    private func configureDataSource(){
    
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            if let chars = item as? CharacterModel {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainViewCell.reuseID, for: indexPath) as! MainViewCell
                cell.set(character: chars)
                return cell
            }else if let comics = item as? ComicsResult {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicsCell.reuseID, for: indexPath) as! ComicsCell
                cell.setforComics(comic: comics)
                return cell
            }else {
                self.presentMrAlert(title: "Unknown Cell", message: "Invalid cell type.", buttonTitle: "Ok")
                fatalError("Unknown cell type")
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicsCell.reuseID, for: indexPath) as! ComicsCell
            
            return cell
            
        })
    }
    
    private func getCharacters(offset: Int){
//        showLoadingView()
        isLoadingMoreData = true
        Task{
            do {
                let charFromApi = try await NetworkManager.shared.getDataGeneric(for: EndPoints.charactersUrl(offset: offset), data: CharacterResponse.self)
                let comicFromApi = try await NetworkManager.shared.getDataGeneric(for: EndPoints.comicsUrl(offset: offset), data: ComicsResponse.self)
                updateData(character: charFromApi.data.results,comics: comicFromApi.data.results)
//                updateUI(charResult: charFromApi, comics: nil)
//                dissmisLoadingView()
                isLoadingMoreData = false
            }catch{
                if let err = error as? marvelError{
                    presentMrAlert(title: "Bad stuff happend", message: err.rawValue, buttonTitle: "Ok")
                }else {
                    presentDefaultError()
                }
//                dissmisLoadingView()
            }
        }
    }
    
    private func getComics(offset: Int){
//        showLoadingView()
        isLoadingMoreData = true
        Task {
            do {
//                let comicFromApi = try await NetworkManager.shared.getDataGeneric(for: EndPoints.comicsUrl(offset: offset), data: ComicsResponse.self)
//                updateUI(charResult: nil, comics: comicFromApi)
//                dissmisLoadingView()
                isLoadingMoreData = false
            }catch{
                if let err = error as? marvelError {
                    presentMrAlert(title: "Bad stuff happened", message: err.rawValue, buttonTitle: "Ok")
                }else {
                    presentDefaultError()
                }
//                dissmisLoadingView()
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
    
    private func updateData(character: [CharacterModel],comics:[ComicsResult]){
        var snapShot = NSDiffableDataSourceSnapshot<Section,AnyHashable>()
//        defer {
//            dataSource.apply(snapShot)
//        }
        snapShot.appendSections([.character,.comics])
        snapShot.appendItems(comics,toSection: .comics)
        snapShot.appendItems(character, toSection: .character)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapShot, animatingDifferences: true)
        }
    }
//
//    private func updateUI(charResult: CharacterResponse?, comics: ComicsResponse?){
//
//        if let char = charResult {
//            if characterArr.count == char.data.total { self.hasMoreDataForChar = false } //For pagination
//            self.characterArr.append(contentsOf: char.data.results)//For pagination
//            print("Char arrcount : ", characterArr.count)
//            self.updateData(character: characterArr, comics: nil)
//
//        }
//        if let comic = comics {
//            if comicsArr.count == comic.data.total { self.hasMoreDataForComics = false }
//            self.comicsArr.append(contentsOf: comic.data.results)
//            print("ComicsArr count: ", comicsArr.count)
//            self.updateData(character: nil, comics: comicsArr)
//        }
//
//
//    }
}

extension MainVC:UICollectionViewDelegate {
        
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

//        if indexPath.item >= characterArr.count - 3  {
//            guard hasMoreDataForChar,!isLoadingMoreData else { return }
//            pageNum += 1
//            offset = pageNum * 20
//            getCharacters(offset: offset)
//        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO
    }
}


