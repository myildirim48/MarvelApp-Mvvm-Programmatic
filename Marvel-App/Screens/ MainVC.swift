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
        case comics
    }
    
    private var characters : CharacterResponse?
    private var characterArr:   [CharacterModel] = []
    private var filteredCharacters : [CharacterModel] = []
    
    private var pageNum = 0
    private var offset = 0
    private var hasMoreData = true
    private var isSearching = false
    private var isLoadingMoreData = false
    
    private var collectionView : UICollectionView!
    private var dataSource : UICollectionViewDiffableDataSource<MainVC.Section,CharacterModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        getData(offset: offset)
    }
    
    private func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.horizontalFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: MainViewCell.reuseID)
    }
    private func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Section,CharacterModel>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainViewCell.reuseID, for: indexPath) as! MainViewCell
            cell.set(character: itemIdentifier)
            return cell
        })
    }
    
    private func getData(offset: Int){
        showLoadingView()
        isLoadingMoreData = true
        Task{
            do {
                let data = try await NetworkManager.shared.getDataGeneric(for: EndPointsStruct.charactersUrl(offset: offset), data: CharacterResponse.self)
                characters = data
                updateUI(with: data)
                dissmisLoadingView()
                isLoadingMoreData = false
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
    
    private func updateData(on charResult: [CharacterModel]){
        var snapShot = NSDiffableDataSourceSnapshot<Section,CharacterModel>()
        snapShot.appendSections([.character])
        snapShot.appendItems(charResult)
        DispatchQueue.main.async {
            self.dataSource.apply(snapShot, animatingDifferences: true)
        }
    }
    
    private func updateUI(with charResult: CharacterResponse ){
        if characterArr.count == charResult.data.total { self.hasMoreData = false } //For pagination
        self.characterArr.append(contentsOf: charResult.data.results)//For pagination
        print(characterArr.count)
//        characterArr = charResult.data.results
        self.updateData(on: self.characterArr)
    }
}

extension MainVC:UICollectionViewDelegate {
        
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if indexPath.item >= characterArr.count - 3  {
            guard hasMoreData,!isLoadingMoreData else { return }
            pageNum += 1
            offset = pageNum * 20
            getData(offset: offset)
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO
    }
}


