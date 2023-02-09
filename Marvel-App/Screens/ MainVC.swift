//
//  MainVC.swift
//  Marvel-App
//
//  Created by YILDIRIM on 8.02.2023.
//

import UIKit

class  MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        Task {
            let data = try await NetworkManager.shared.getDataGeneric(for: EndPoints.charactersUrl(page: 1), data: GameDetail.self)
            print(data)
        }
    }
}

