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
    private var searchResultVM : SearchResultVM!
    
    private var dataSource : HeroDataSource?
    
    var searchController: UISearchController!
    var searchResultVC: SearchResultVC!
    
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
        searchResultVM = SearchResultVM(environment: environment)
        defer { viewModel.requestData() }

        let dataSource = generateDatasource(for: collectionView)
        viewModel.configureDataSource(with: dataSource)
        viewModel.errorHandler = self
        
        configureCollectionView()
        configureSearch()
        
        let searchDataSource = generateDatasource(for: searchResultVC.collectionView)
        searchResultVM.configureDataSource(with: searchDataSource)
        searchResultVM.errorHandler = self
    }
    
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(HeroCell.self, forCellWithReuseIdentifier: HeroCell.reuseID)
        collectionView.register(LoaderReusableView.self, forSupplementaryViewOfKind: LoaderReusableView.elementKind, withReuseIdentifier: LoaderReusableView.reuseIdentifier)
    }
    
    
    private func configureSearch(){
        searchResultVC = SearchResultVC(collectionViewLayout: UICollectionViewLayoutGenerator.generateLayoutForStyle(.search))
        searchResultVC.searchResultVM = searchResultVM
        searchResultVC.collectionView.delegate = self
        
        searchController = UISearchController(searchResultsController: searchResultVC)
        searchController.searchResultsUpdater = searchResultVC
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a hero.."
        
        definesPresentationContext = true
        navigationItem.searchController = searchController
    }
    
}
//MARK: - CollectionView Delegate

extension HeroListVC {

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.collectionView: viewModel.shouldFetchData(index: indexPath.item)
        case searchResultVC.collectionView: searchResultVM.shouldFetchData(index: indexPath.item)
        default: return
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCharacter: Characters!
        switch collectionView {
        case self.collectionView: selectedCharacter = viewModel.item(for: indexPath)
        case searchResultVC.collectionView: selectedCharacter = searchResultVM.item(for: indexPath)
        default : return
        }
        
        
        let detailVC = DetailVC(environment: environment)
        detailVC.charachter = selectedCharacter
        
        let navController = UINavigationController(rootViewController: detailVC)
        present(navController, animated: true)
    }
}

//MARK: - Data Source Generator

extension HeroListVC {
    public func generateDatasource(for collectionView: UICollectionView) -> HeroDataSource {
        
        let dataSource = HeroDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, character) -> UICollectionViewCell? in
//            guard let self = self else { return nil }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCell.reuseID, for: indexPath) as! HeroCell
            
            cell.character = character
            
            //-> TODO ----->
            //Button and Delegate
            //Image fetcher
            //<-----
            
            return cell
        })
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            switch kind {
            case LoaderReusableView.elementKind:
                let loaderSupplementary = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoaderReusableView.reuseIdentifier, for: indexPath) as! LoaderReusableView
                return loaderSupplementary
            case SearchResuableView.elementKind:
                let searchSupplementary = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchResuableView.reuseIdentifier, for: indexPath) as! SearchResuableView
                self?.searchResultVC.searchInfoView = searchSupplementary
                return searchSupplementary
            default:
                return nil
            }
        }
        return dataSource
    }
}

//MARK: - Error Handlers

extension HeroListVC: HeroListViewModelErrorHandler, SearchResultVMErrorHandler {
    
    func viewModelDidReceiveError(error: UserFriendlyError) {
        presentMrAlert(title: error.title, message: error.message, buttonTitle: "Ok")
    }
}

