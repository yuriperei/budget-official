//
//  MenuTableViewController.swift
//  Budget
//
//  Created by md10 on 3/23/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    // MARK: - Functions generated
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = Color.uicolorFromHex(0xffffff)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch(section) {
        case 0: return 4    // section 0 has 4 rows
        case 1: return 4    // section 1 has 4 row
        case 2: return 1    // section 2 has 1 row
        default: fatalError("Unknown number of sections")
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Futura", size: 13)!
        header.textLabel?.textColor = Color.uicolorFromHex(0x274561)
        header.tintColor = Color.uicolorFromHex(0xf2f2f2f2)
    }
}