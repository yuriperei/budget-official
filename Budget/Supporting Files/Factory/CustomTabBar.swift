//
//  CustomTabBar.swift
//  Budget
//
//  Created by Yuri Pereira on 3/19/16.
//  Copyright © 2016 Budget. All rights reserved.
//


import UIKit

class CustomTabBar: UIViewController {

    static func custom(inout tabBar: UITabBar) {
        
        // To change tintColor for unselect tabs
        for item in tabBar.items! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(Color.uicolorFromHex(0x9ee9e1)).imageWithRenderingMode(.AlwaysOriginal)
            }
        }
    }
}
