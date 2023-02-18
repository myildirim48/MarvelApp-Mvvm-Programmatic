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
    
    private var searchedChar: NetworkResponse<CharacterModel>?
    private var characterArr:   [CharacterModel] = []
    private var filteredCharacters : [CharacterModel] = []
    
    private typealias charResponse = NetworkResponse<CharacterModel>
    
    private var pageNumChar = 0
    private var offset = 0
    private var timer : Timer?
    private var isSearching = false
    private var isLoadingMoreData = false
    private var hasMoreData = false
    private var searchText = ""
    
    private var collectionView : UICollectionView!
    private var dataSource : UICollectionViewDiffableDataSource<Section,CharacterModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        getCharacters(offset: offset)
        configureDataSource()
        configureSearchController()
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
        showLoadingView()
        isLoadingMoreData = true
        Task{
            do {
                let charFromApi = try await NetworkManager.shared.getDataGeneric(for: EndPoints.charactersUrl(offset: offset), data: charResponse.self)
                updateUI(with: charFromApi)
                dissmisLoadingView()
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

    private func updateUI(with char: charResponse){
        if characterArr.count == char.data.total {
            hasMoreData = false
            return } //For pagination
        hasMoreData = true
        self.characterArr.append(contentsOf: char.data.results)//For pagination
        updateChars(char: characterArr)
    }
    
    
    private func updateChars(char:[CharacterModel]){
        var snapShot = NSDiffableDataSourceSnapshot<Section,CharacterModel>()
        snapShot.appendSections([.main])
        snapShot.appendItems(char)
        DispatchQueue.main.async {
            self.dataSource.apply(snapShot, animatingDifferences: true)
        }
    }
    
    
    private func configureSearchController(){
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a character.."
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func searchChars(searchText:String,offset:Int){
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
            guard let self = self else { return }
            Task {
                self.showLoadingView()
                let searchedData = try await NetworkManager.shared.getDataGeneric(for: EndPoints.characterSearch(searchText: searchText, offset: offset), data: charResponse.self)
                if self.loadingContainerView != nil { self.dissmisLoadingView() }
                
                if searchedData.data.count >= self.filteredCharacters.count && searchedData.data.count > 0 {
                    self.filteredCharacters  = searchedData.data.results
                    self.updateChars(char: self.filteredCharacters)
                }else {
                    self.presentMrAlert(title: "No Search Result", message: "No search Result for \(searchText)", buttonTitle: "Ok")
                    self.updateChars(char: [])
                }
            }
        })
    }
}
extension MainVC:UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let hegiht = scrollView.frame.size.height
        
        if offsetY > contentHeight - hegiht - 100 && hasMoreData{
            if !isSearching {
                guard !isSearching,!isLoadingMoreData else { return }
                pageNumChar += 1
                offset = pageNumChar * 20
                getCharacters(offset: offset)
            } else if isSearching && hasMoreData {
                guard !isLoadingMoreData else { return }
            }

      
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let activeArray = isSearching ? filteredCharacters : characterArr
        let character = activeArray[indexPath.item]
        
        let detailVC = DetailVC()
        detailVC.charachter = character
        
        let navController = UINavigationController(rootViewController: detailVC)
        present(navController, animated: true)
    }
}

extension MainVC : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            updateChars(char: characterArr)
            isSearching = false
            return
        }
        isSearching = true
        searchText = filter
        searchChars(searchText: filter,offset: 0)
  
    }
    
    
}


