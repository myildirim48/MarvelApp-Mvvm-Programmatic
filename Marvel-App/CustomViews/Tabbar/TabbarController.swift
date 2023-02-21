//
//  TabbarController.swift
//  Marvel-App
//
//  Created by YILDIRIM on 8.02.2023.
//

import UIKit

class TabbarController: UITabBarController {
    
    var environment: Environment!

    required init?(coder:NSCoder) {
        self.environment = Environment(server: Server())
        super.init(coder: coder)
    }
    required init(environment: Environment?) {
        self.environment = environment
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabbarApperance = UITabBar.appearance()
        tabbarApperance.tintColor = .systemRed
        tabbarApperance.backgroundColor = .systemGray6
        viewControllers = [createTabbarItem(view: HeroListVC(environemnt: environment, layout: UICollectionViewLayoutGenerator.generateLayoutForStyle(.paginated)), title: "Heros", itemImage: TabbarImgName.mainVCImage)
                           ,createTabbarItem(view: FavoriteVC(), title: "Favorites", itemImage: TabbarImgName.favoriteVCImage)]
    }
    
    func createTabbarItem(view: UIViewController ,title:String, itemImage: String) -> UINavigationController{
        
        
        let navController = view
        
        navController.title = title
        navController.tabBarItem.image = UIImage(systemName: itemImage)
        navController.tabBarItem.title = title
        return UINavigationController(rootViewController: navController)
        
    }
}
