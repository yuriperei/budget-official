//
//  CompraPrazoVistaViewController.swift
//  Budget
//
//  Created by md10 on 3/17/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import JavaScriptCore

class CompraPrazoVistaViewController: UITableViewController {

    @IBOutlet weak var txtParcelas: UITextField!
    @IBOutlet weak var txtValorParcela: UITextField!
    @IBOutlet weak var txtValorFinanciado: UITextField!
    @IBOutlet weak var lblResultadoJuros: UILabel!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var btnSideBar: UIBarButtonItem!
    
    var finance: Finance!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        finance = Finance()
//        print(finance.cagr(704.28, 30000, 3))
//        print(finance.calculateCompoundInterest(720, 12, 62.5))
        SidebarMenu.configMenu(self, sideBarMenu: btnSideBar)
        FormCustomization.updateWidthsForLabels(labels)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func maskTextField(sender: UITextField) {
        FormCustomization.aplicarMascara(&sender.text!)
    }

    @IBAction func calcularJuros(sender: AnyObject) {
        let parcelas: Int = Int(txtParcelas.text!)!
        let valorParcela: Double = txtValorParcela.text!.doubleConverterMoeda()
        let valorFinanciado: Double = txtValorFinanciado.text!.doubleConverterMoeda()
        
        lblResultadoJuros.text = String.init(format: "%.2f", finance.calculateCompoundInterest(valorFinanciado, parcelas, valorParcela))+"%"
//        print(finance.cagr(704.28, 30000, 3))
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch(section) {
            case 0: return 3    // section 0 has 2 rows
            case 1: return 1    // section 1 has 1 row
            case 2: return 1    // section 2 has 1 row
            default: fatalError("Unknown number of sections")
        }
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
