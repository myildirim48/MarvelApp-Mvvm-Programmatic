//
//  TabbarController.swift
//  Marvel-App
//
//  Created by YILDIRIM on 8.02.2023.
//

import UIKit

class TabbarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabbarApperance = UITabBar.appearance()
        tabbarApperance.tintColor = .systemRed
        tabbarApperance.backgroundColor = .systemGray6
        viewControllers = [createMainVC()]
    }
    
    func createMainVC() -> UINavigationController{
        let mainVC = MainVC()
        
        mainVC.title = "Main"
        mainVC.tabBarItem.image = UIImage(systemName: "book.circle")
        mainVC.tabBarItem.title = "Main"
        return UINavigationController(rootViewController: mainVC)
    }
}
