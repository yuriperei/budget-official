//
//  CompraPrazoVistaViewController.swift
//  Budget
//
//  Created by md10 on 3/17/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import JavaScriptCore

class CompraPrazoVistaViewController: UITableViewController, UIGestureRecognizerDelegate {

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
        
        addDismissInputView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func maskTextField(sender: UITextField) {
        FormCustomization.aplicarMascaraMoeda(&sender.text!)
    }

    @IBAction func calcularJuros(sender: AnyObject) {
        let parcelas: Int = Int(txtParcelas.text!)!
        let valorParcela: Double = txtValorParcela.text!.currencyToDouble()
        let valorFinanciado: Double = txtValorFinanciado.text!.currencyToDouble()
        
        lblResultadoJuros.text = String.init(format: "%.2f", finance.calculateCompoundInterest(valorFinanciado, parcelas, valorParcela))+"%"
//        print(finance.cagr(704.28, 30000, 3))
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
    
    // MARK: - IBAction functions
    @IBAction func maskTextField(sender: UITextField) {
        FormCustomization.aplicarMascaraMoeda(&sender.text!)
    }
    
    @IBAction func calcularJuros(sender: AnyObject) {
        if let parcelas = txtParcelas.text, let valorParcela = txtValorParcela.text, let valorFinanciado = txtValorFinanciado.text {

            if (!parcelas.isEmpty && !valorParcela.isEmpty && !valorFinanciado.isEmpty) {
                
                lblResultadoJuros.text = String.init(format: "%.2f", finance.calculateCompoundInterest(valorFinanciado.currencyToDouble(), parcelas.intValue, valorParcela.currencyToDouble()))+"%"
            }
        }
    }
    
    // MARK: - Private Functions
    
    private func addDismissInputView() {
        let tap = UITapGestureRecognizer(target: self, action: Selector("dismiss:"))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    // MARK: - Selector Functions
    
    func dismiss(sender: UITapGestureRecognizer? = nil) {
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