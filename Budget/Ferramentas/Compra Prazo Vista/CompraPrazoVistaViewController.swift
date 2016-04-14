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

    @IBOutlet var textViews:[UITextField]!
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
        SidebarMenu.configMenu(self, sideBarMenu: btnSideBar)
        
        FormCustomization.alignLabelsWidths(labels)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch(section) {
            case 0: return 4    
            case 1: return 1    
            case 2: return 1
            default: fatalError("Unknown number of sections")
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        FormCustomization.dismissInputView(textViews)
    }
    
    // MARK: - IBAction functions

    @IBAction func touchButton(sender: UIButton) {
        FormCustomization.dismissInputView(textViews)
    }
    
    @IBAction func maskTextField(sender: UITextField) {
        FormCustomization.aplicarMascaraMoeda(&sender.text!)
    }
    
    @IBAction func calcularJuros(sender: AnyObject) {
        if let parcelas = txtParcelas.text, let valorParcela = txtValorParcela.text, let valorFinanciado = txtValorFinanciado.text {

            if (!parcelas.isEmpty && !valorParcela.isEmpty && !valorFinanciado.isEmpty) {
                
                lblResultadoJuros.text = String.init(format: "%.2f", finance.calculateCompoundInterest(valorFinanciado.currencyToDouble(), parcelas.intValue, valorParcela.currencyToDouble()))+"%"
            }
        }
        FormCustomization.dismissInputView(textViews)
    }
}
/*
Comentários temporários
//        print(finance.cagr(704.28, 30000, 3))
//        print(finance.calculateCompoundInterest(720, 12, 62.5))
// section 0 has 2 rows
// section 1 has 1 row
// section 2 has 1 row
//        print(finance.cagr(704.28, 30000, 3))

//            let parcelas: Int = Int(txtParcelas.text!)!
//            let valorParcela: Double = txtValorParcela.text!.currencyToDouble()
//            let valorFinanciado: Double = txtValorFinanciado.text!.currencyToDouble()
*/