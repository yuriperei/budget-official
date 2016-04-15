//
//  PorcentagemTableViewController.swift
//  Budget
//
//  Created by Yuri Pereira on 4/8/16.
//  Copyright © 2016 Budget Company. All rights reserved.
//

import UIKit

class PorcentagemTableViewController: UITableViewController {
    
    @IBOutlet var btnSidebar:UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SidebarMenu.configMenu(self, sideBarMenu: btnSidebar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if (indexPath.row % 2 == 0){
            cell.backgroundColor = Color.uicolorFromHex(0xf9f9f9)
        }else{
            cell.backgroundColor = Color.uicolorFromHex(0xffffff)
        }
    }
}
