//
//  FavoriteVC.swift
//  Marvel-App
//
//  Created by YILDIRIM on 16.02.2023.
//

import UIKit

class FavoriteVC: UICollectionViewController {
    
    private let environment: Environment!
    private let favoritesViewModel: FavoritesViewModel!
    
    required init?(coder: NSCoder) {
        self.environment = Environment(server: Server(), store: Store())
        self.favoritesViewModel = FavoritesViewModel(environment: environment)
        super.init(coder: coder)
    }
    
    required init(environemt: Environment, layout: UICollectionViewLayout) {
        self.environment = environemt
        self.favoritesViewModel = FavoritesViewModel(environment: environemt)
        super.init(collectionViewLayout: layout)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = generateDatsource()
        favoritesViewModel.configureDataSource(with: dataSource)
        
        configureCollectionView()
    }
    
    private func configureCollectionView(){
        collectionView.backgroundColor = .systemBackground
        collectionView.register(HeroCell.self, forCellWithReuseIdentifier: HeroCell.reuseID)
    }
    
    func generateDatsource() -> HeroDataSource{
     
        let dataSource = HeroDataSource(collectionView: collectionView) { [weak self] (collectionView, indexPath, character) -> UICollectionViewCell?  in
            guard let self = self else { return nil }

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCell.reuseID, for: indexPath) as! HeroCell
            cell.favoritesButton.isSelected = self.environment.store.viewContext.hasPersistenceId(for: character)
            cell.character = character
            cell.delegate = self

            if let data = character.thumbnail?.data, let image = UIImage(data: data) {
                cell.update(image: image)
            } else {
                cell.update(image: nil)
            }
            return cell
        }

        return dataSource
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCharacter = favoritesViewModel.item(for: indexPath)!

        let detailVC = DetailVC(environment: environment)
        detailVC.charachter = selectedCharacter
        
        let navController = UINavigationController(rootViewController: detailVC)
        present(navController, animated: true)
    }
}
extension FavoriteVC: HeroCellDelegate {
    func heroCellFavoriteButtonTapped(cell: HeroCell) {
        guard let character = cell.character else { return }
        presentAlertWithStateChange(message: .deleteCharacter(with: character)) { [weak self] status in
            guard let self = self, let environment = self.environment  else { return }
            if status { environment.store.toggleStorage(for: character, completion: {_ in})}
        }
    }
}

