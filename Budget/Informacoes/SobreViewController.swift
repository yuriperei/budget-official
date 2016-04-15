//
//  SobreViewController.swift
//  Budget
//
//  Created by Yuri Pereira on 4/11/16.
//  Copyright © 2016 Budget Company. All rights reserved.
//

import UIKit

class SobreViewController: UIViewController {
    
    @IBOutlet var btnSidebar:UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SidebarMenu.configMenu(self, sideBarMenu: btnSidebar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
