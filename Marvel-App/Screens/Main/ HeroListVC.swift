//
//  HeroListVC.swift
//  Marvel-App
//
//  Created by YILDIRIM on 8.02.2023.
//

import UIKit


class HeroListVC: UICollectionViewController{
    
    private let environment: Environment!
    private var timer : Timer?
    
    private var viewModel : HeroListVM!
    private var dataSource : HeroDataSource?
    
    required init?(coder:NSCoder) {
        self.environment = Environment(server: Server())
        super.init(coder: coder)
    }
    
    required init(environemnt: Environment, layout: UICollectionViewLayout) {
        self.environment = environemnt
        super.init(collectionViewLayout: layout)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HeroListVM(environment: environment)
        defer { viewModel.requestData() }

        let dataSource = generateDatasource(for: collectionView)
        viewModel.configureDataSource(with: dataSource)
        viewModel.errorHandler = self
        
        configureCollectionView()
        configureSearchController()
    }
    
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(HeroCell.self, forCellWithReuseIdentifier: HeroCell.reuseID)
        collectionView.register(LoaderReusableView.self, forSupplementaryViewOfKind: LoaderReusableView.elementKind, withReuseIdentifier: LoaderReusableView.reuseIdentifier)
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
 
            //TODO for pagination
        })
    }
}
//MARK: - CollectionViewDelegate

extension HeroListVC {

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.collectionView: viewModel.shouldFetchData(index: indexPath.item)
//            case //TODO SearchVC
        default: return
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                
        let detailVC = DetailVC()
//        detailVC.charachter = character
        
        let navController = UINavigationController(rootViewController: detailVC)
        present(navController, animated: true)
    }
}

extension HeroListVC : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {

  
    }
    
    
}
//MARK: - Data Source Generator

extension HeroListVC {
    public func generateDatasource(for collectionView: UICollectionView) -> HeroDataSource {
        
        let dataSource = HeroDataSource(collectionView: collectionView, cellProvider: { [weak self] (collectionView, indexPath, character) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCell.reuseID, for: indexPath) as! HeroCell
            
            cell.character = character
            //Button and Delegate
            
            
            //Image fetcher
            return cell
        })
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            switch kind {
            case LoaderReusableView.elementKind:
                let loaderSupplementary = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoaderReusableView.reuseIdentifier, for: indexPath) as! LoaderReusableView
                return loaderSupplementary
                
            default:
                return nil
            }
        }
        return dataSource
    }
}

//MARK: - Error Handlers

extension HeroListVC: HeroListViewModelErrorHandler {
    func viewModelDidReceiveError(error: UserFriendlyError) {
        presentMrAlert(title: error.title, message: error.message, buttonTitle: "Ok")
    }
    

}

