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
        viewControllers = [createTabbarItem(view: MainVC() , title: "Main", itemImage: TabbarImgName.mainVCImage),
                           createTabbarItem(view: FavoriteVC(), title: "Favorites", itemImage: TabbarImgName.favoriteVCImage)]
    }
    
    func createTabbarItem(view: UIViewController ,title:String, itemImage: String) -> UINavigationController{
        
        
        let navController = view
        
        navController.title = title
        navController.tabBarItem.image = UIImage(systemName: itemImage)
        navController.tabBarItem.title = title
        return UINavigationController(rootViewController: navController)
        
    }
}
