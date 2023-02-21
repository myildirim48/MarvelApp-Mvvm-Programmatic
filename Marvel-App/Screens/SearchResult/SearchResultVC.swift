//
//  SearchResultVC.swift
//  Marvel-App
//
//  Created by YILDIRIM on 21.02.2023.
//

import UIKit
class SearchResultVC: UICollectionViewController {
    
    var searchResultVM: SearchResultVM!
    var searchInfoView: SearchResuableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultVM.infoHandler = self
        configureCollectionView()
    }
    
    private func configureCollectionView(){
        collectionView.backgroundColor = .systemBackground
        collectionView.register(HeroCell.self, forCellWithReuseIdentifier: HeroCell.reuseID)
        collectionView.register(SearchResuableView.self, forSupplementaryViewOfKind: SearchResuableView.elementKind, withReuseIdentifier: SearchResuableView.reuseIdentifier)
    }
}
extension SearchResultVC: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let strippedString = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces), !strippedString.isEmpty else { return  }
        
        searchResultVM.performSearch(with: strippedString)
    }
    func willDismissSearchController(_ searchController: UISearchController) {
        searchResultVM.resetSearchResult()
    }
}

extension SearchResultVC: SearchResultVMInformatinHandler {
    func presentSearchActivitty() {
        guard let searchInfoView = searchInfoView else { return }
        searchInfoView.presentActivityIndicator()
    }
    
    func presentSearchResult(with count: Int) {
        guard let searchInfoView = searchInfoView else { return }
        searchInfoView.presentInformation(count: count)
    }
    
    
}
