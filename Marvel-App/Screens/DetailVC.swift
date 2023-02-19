//
//  DetailVC.swift
//  Marvel-App
//
//  Created by YILDIRIM on 16.02.2023.
//

import UIKit

class DetailVC: LoadingVC {

    let imageView = ImageView(frame: .zero)
    let nameLabel = MrLabel(textAligment: .left, font: Theme.fonts.titleFont)
    let descriptionLabel = MrLabel(textAligment: .left, font: Theme.fonts.desriptionFont)
    let favoritedButton = FavoritesButton(frame: .zero)
    
    var charachter: CharacterModel? {
        didSet {
            update()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        setupUI()
        
    }
    
    @objc func favoriteButtonTapped(_ sender: UIButton){
        Task{
            do {
                let charFromApi = try await NetworkManager.shared.getDataGeneric(for: EndPoints.charDetailDatas(charId: charachter?.id ?? 0), data: NetworkResponse<Comics>.self)
                print(charFromApi)
            }catch{
                if let err = error as? marvelError{
                    presentMrAlert(title: "Bad stuff happend", message: err.rawValue, buttonTitle: "Ok")
                }else {
                    presentDefaultError()
                }
                if loadingContainerView != nil { dissmisLoadingView() }
            }
        }
        sender.isSelected = sender.isSelected == true ? false : true
        
    }
    
    private func update(){
        guard let charachter = charachter else {
            nameLabel.text = nil
            descriptionLabel.text = nil
            return
        }
        
        title = charachter.name
        nameLabel.text = charachter.name
        descriptionLabel.text = charachter.description.isEmpty ? unavailableDescription : charachter.description
        imageView.downloadImage(fromUrl: charachter.thumbnail.path)
        
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        UINavigationBar.appearance().backgroundColor = .systemRed
    }
    
    
    private func setupUI() {
        
        view.addSubviews(imageView,nameLabel,descriptionLabel,favoritedButton)
        view.backgroundColor = .systemBackground
        
        favoritedButton.addTarget(self, action: #selector(self.favoriteButtonTapped(_:)), for: .touchUpInside)
        
        let spacing : CGFloat = 12
        let imgHeight : CGFloat = view.frame.height / 2.5
        
        
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor,constant: spacing*2),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: imgHeight),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 2*spacing),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: spacing),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -spacing),
            
            favoritedButton.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: spacing),
            favoritedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -spacing),
            favoritedButton.widthAnchor.constraint(equalToConstant: 40),
            favoritedButton.heightAnchor.constraint(equalToConstant: 37),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 2*spacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
            
        ])
    }
    @objc func dismissVC() {

        dismiss(animated: true)
    }
    
}
