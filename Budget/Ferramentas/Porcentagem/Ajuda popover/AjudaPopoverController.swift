//
//  AjudaPopoverController.swift
//  Budget
//
//  Created by md10 on 4/7/16.
//  Copyright © 2016 Budget Company. All rights reserved.
//

import UIKit

class AjudaPopoverController: UIViewController {
    
    @IBOutlet weak var lblAjuda: UILabel!
    var txtLabel:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblAjuda.text = txtLabel
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}