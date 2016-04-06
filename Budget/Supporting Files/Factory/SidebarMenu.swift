//
//  SidebarMenu.swift
//  Budget
//
//  Created by Calebe Santos on 4/3/16.
//  Copyright © 2016 Budget Company. All rights reserved.
//

import UIKit

class SidebarMenu {
    static func configMenu(viewController:UIViewController, sideBarMenu: UIBarButtonItem){
        sideBarMenu.target = viewController.revealViewController()
        sideBarMenu.action = Selector("revealToggle:")
        viewController.view.addGestureRecognizer(viewController.revealViewController().panGestureRecognizer())
    }
}