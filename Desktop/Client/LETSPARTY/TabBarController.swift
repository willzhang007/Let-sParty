//
//  TabBarController.swift
//  LETSPARTY
//
//  Created by LinLin Ding on 10/29/16.
//  Copyright © 2016 LinLin Ding. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBar: UITabBar=self.tabBar
        let item0:UITabBarItem=tabBar.items![0]
        let item1:UITabBarItem=tabBar.items![1]
        let item2:UITabBarItem=tabBar.items![2]
        let item3:UITabBarItem=tabBar.items![3]
        
        item0.image=#imageLiteral(resourceName: "partyLogo1")
        item1.image=#imageLiteral(resourceName: "earth-usa.png")
        item2.image=#imageLiteral(resourceName: "id-card.png")
        item3.image=#imageLiteral(resourceName: "partyLogo5.png")
       // party
    }


    

   }
