//
//  ValorFuturoTableViewController.swift
//  Budget
//
//  Created by Calebe Santos on 4/6/16.
//  Copyright © 2016 Budget Company. All rights reserved.
//

import UIKit

class ValorFuturoTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    var finance:Finance = Finance()
    
    @IBOutlet var textViews:[UITextField]!
    @IBOutlet var btnSidebar: UIBarButtonItem!
    @IBOutlet var txtValorDepositado: UITextField!
    @IBOutlet var txtNumeroMeses: UITextField!
    @IBOutlet var txtJuros: UITextField!
    @IBOutlet var lblResultado: UILabel!
    @IBOutlet var labels:[UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SidebarMenu.configMenu(self, sideBarMenu: btnSidebar)
        FormCustomization.alignLabelsWidths(labels)
        addDismissInputView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction functions
    
    @IBAction func maskTextfield(sender: UITextField) {
        FormCustomization.aplicarMascaraMoeda(&sender.text!)
    }
    
    @IBAction func calcularValorFuturo(sender: AnyObject) {
        let taxaJuros = (txtJuros.text?.floatConverter)!
        let valorDepositado = (txtValorDepositado.text?.currencyToDouble())!
        let numeroParcelas = (txtNumeroMeses.text?.intValue)!
        
        lblResultado.text = finance.calculateFutureValue(taxaJuros, valorDepositado: valorDepositado, numeroDeParcelas: numeroParcelas).convertToCurrency("pt_BR")
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
