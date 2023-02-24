//
//  DetailVC.swift
//  Marvel-App
//
//  Created by YILDIRIM on 16.02.2023.
//

import UIKit

class DetailVC: UIViewController {

    static let nibIdentifier = "HeroDetailViewController"

    var charachter: Characters?
    private let environment: Environment!
    private var detailViewModel: DetaiLVM!
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    var collectionView : UICollectionView!
    
    let imageView = ImageView(frame: .zero)
    let nameLabel = MrLabel(textAligment: .left, font: Theme.fonts.titleFont)
    let descriptionLabel = MrLabel(textAligment: .left, font: Theme.fonts.desriptionFont)
    let favoritedButton = FavoritesButton(frame: .zero)
    
    required init(environment: Environment) {
        self.environment = environment
        super.init(nibName: nil, bundle: nil)
        
        self.detailViewModel = DetaiLVM(environment: environment)
    }
    
    required init?(coder: NSCoder) {
        self.environment = Environment(server: Server(),store: Store())
        super.init(coder: coder)
        
        self.detailViewModel = DetaiLVM(environment: environment)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollView()
        configureCollectionView()
        setupUI()
        
        detailViewModel.delegate = self
        let dataSource = configureDataSource()
        detailViewModel.datasource = dataSource
        detailViewModel.character = charachter
        
        guard let charachter = charachter else { return }
        update(with: charachter)
    }
    
    @objc func favoriteButtonTapped(_ sender: UIButton){
        presentPersistenceAlert()
        
    }
    
    private func update(with character: Characters){
        guard let charachter = charachter else {
            nameLabel.text = nil
            descriptionLabel.text = nil
            return
        }
        
        title = charachter.name
        nameLabel.text = charachter.name
        descriptionLabel.text = charachter.description.isEmpty ? unavailableDescription : charachter.description
        favoritedButton.isSelected = environment.store.viewContext.hasPersistenceId(for: character)
        imageView.downloadImage(fromUrl: charachter.thumbnail?.path ?? " ")
        
    }

    private func configureScrollView(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 1500)
        ])
    }
    
    private func configureCollectionView(){
  
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayoutGenerator.resourcesCollectionViewLayout())
        collectionView.delegate = self
//        collectionView.setCollectionViewLayout(UICollectionViewLayoutGenerator.resourcesCollectionViewLayout(), animated: false)
        collectionView.register(ResourceCell.self, forCellWithReuseIdentifier: ResourceCell.reuseIdentifier)
        collectionView.register(TitleSupplementaryView.self, forSupplementaryViewOfKind: TitleSupplementaryView.elementKind, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
        
    }
    
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    
    private func setupUI() {
        
        contentView.addSubviews(imageView,nameLabel,descriptionLabel,favoritedButton,collectionView)
        view.backgroundColor = .systemBackground
        
        favoritedButton.addTarget(self, action: #selector(self.favoriteButtonTapped(_:)), for: .touchUpInside)
        
        let spacing : CGFloat = 12
        let imgHeight : CGFloat = view.frame.height / 2.5
        
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: spacing*2),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: imgHeight),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 2*spacing),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: spacing),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -spacing),
            
            favoritedButton.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: spacing),
            favoritedButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -spacing),
            favoritedButton.widthAnchor.constraint(equalToConstant: 40),
            favoritedButton.heightAnchor.constraint(equalToConstant: 37),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 2*spacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,constant: spacing),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
    }
    @objc func dismissVC() {

        dismiss(animated: true)
    }
    
}

extension DetailVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        TODO
    }
    
    private func configureDataSource() -> ResourceDataSource {
        let datasource = ResourceDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResourceCell.reuseIdentifier, for: indexPath) as! ResourceCell
            cell.titleLabel.text = itemIdentifier.title
            cell.imageView.downloadImage(fromUrl: itemIdentifier.thumbnail.path ?? " ",placeHolderImage: Images.placeHolderResourceImage)
            return cell
        }
        
        datasource.supplementaryViewProvider = {
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            let titleSupplementary = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier, for: indexPath) as! TitleSupplementaryView
            
            let section = UICollectionViewLayoutGenerator.ResourceSection(rawValue: indexPath.section)!
            titleSupplementary.label.text = section.sectionTitle
            
            return titleSupplementary
        }
        return datasource
    }
    
}

extension DetailVC: HeroDetailViewModelDelegate {
    func viewModelDidReceiveError(error: UserFriendlyError) {
        presentAlertWithError(message: error) { _ in }
    }
    
    func viewModelDidTogglePersistence(with status: Bool) {
        guard status else { return }
        animateFavoriteButtonSelection()
    }
    
    func animateFavoriteButtonSelection(){
        UIView.transition(with: favoritedButton, duration: 0.25,options: .transitionCrossDissolve) {
            self.favoritedButton.isSelected = !self.favoritedButton.isSelected
        }
    }
    
    func presentPersistenceAlert() {
        guard let message = detailViewModel.composeStateChangeMessage() else { return }
        
        switch message.state {
        case .persisted :
            presentAlertWithStateChange(message: message) { [weak self] status in
                guard status, let self = self else { return }
                
                self.detailViewModel.toggleCharacterPersistence(with: message, data: self.imageView.image?.pngData())
                self.navigationController?.popViewController(animated: true)
            }
        case .memory :
            self.detailViewModel.toggleCharacterPersistence(with: message, data: self.imageView.image?.pngData())
        }
    }
}

