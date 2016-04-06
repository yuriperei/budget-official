//
//  ValorFuturoTableViewController.swift
//  Budget
//
//  Created by Calebe Santos on 4/6/16.
//  Copyright © 2016 Budget Company. All rights reserved.
//

import UIKit

class ValorFuturoTableViewController: UITableViewController {
    
    @IBOutlet var btnSidebar: UIBarButtonItem!
    @IBOutlet var txtValorDepositado: UITextField!
    @IBOutlet var txtNumeroMeses: UITextField!
    @IBOutlet var txtJuros: UITextField!
    @IBOutlet var lblResultado: UILabel!
    var finance:Finance = Finance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SidebarMenu.configMenu(self, sideBarMenu: btnSidebar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func maskTextfield(sender: UITextField) {
        FormCustomization.aplicarMascara(&sender.text!)
    }
    
    @IBAction func calcularValorFuturo(sender: AnyObject) {
        let taxaJuros = (txtJuros.text?.floatConverterMoeda())!
        let valorDepositado = (txtValorDepositado.text?.doubleConverterMoeda())!
        let numeroParcelas = (txtNumeroMeses.text?.intValue)!
        
        lblResultado.text = finance.calculateFutureValue(taxaJuros, valorDepositado: valorDepositado, numeroDeParcelas: numeroParcelas).convertToMoedaBr()
    }
}
