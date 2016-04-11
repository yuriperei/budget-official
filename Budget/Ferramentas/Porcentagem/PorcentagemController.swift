//
//  CalculadoraJurosController.swift
//  Budget
//
//  Created by Calebe Santos on 3/7/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit

class PorcentagemController: UITableViewController, UIPopoverPresentationControllerDelegate {

    var calculadora: Calculadora?
    
    @IBOutlet weak var lblSegundoValor: UILabel!
    @IBOutlet weak var lblPrimeiroValor: UILabel!
    
    @IBOutlet weak var txtPrimeiroValor: UITextField!
    @IBOutlet weak var txtSegundoValor: UITextField!
    @IBOutlet weak var lblResultado: UILabel!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var sgmTipo: UISegmentedControl!
    @IBOutlet weak var btnSideBar: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SidebarMenu.configMenu(self, sideBarMenu: btnSideBar)
        calculadora = Porcentagem()
        FormCustomization.alignLabelsWidths(labels)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func maskTextField(sender: UITextField) {
        FormCustomization.aplicarMascaraMoeda(&sender.text!)
    }
    
    @IBAction func calcularValorPorcentagem(sender: UIButton) {
        //Porcentagem do valor
        if (sgmTipo.selectedSegmentIndex == 0) {
            calculadora?.numeroAtual = txtSegundoValor.text!.currencyToDouble()
            if let calculadora = calculadora as? Porcentagem {
                calculadora.porcentagem = txtPrimeiroValor.text!.doubleConverter
                lblResultado.text = calculadora.calcularPorcentagemDoValor().convertToCurrency("pt_BR")
            }
        } else {
            calcularPercentualValor(sender)
        }
    }
    
    private func calcularPercentualValor(sender: UIButton) {
        //Valor porcentagem
        calculadora?.numeroAtual = txtPrimeiroValor.text!.currencyToDouble()
        calculadora?.numeroFinal = txtSegundoValor.text!.currencyToDouble()
        
        if let calculadora = calculadora as? Porcentagem {
            lblResultado.text = String(format: "%.4g", calculadora.calcularValorPorcentagem()) + "%"
        }
    }
    
    @IBAction func changeLabelPorcentagem(sender: UISegmentedControl) {
        if (sgmTipo.selectedSegmentIndex == 0) {
            lblPrimeiroValor.text = "Porcentagem:"
            txtPrimeiroValor.text = ""
            txtPrimeiroValor.removeTarget(self, action: "maskTextField:", forControlEvents: .EditingChanged)
        } else {
            lblPrimeiroValor.text = "Valor parcial:"
            txtPrimeiroValor.text = "R$0,00"
            txtPrimeiroValor.addTarget(self, action: "maskTextField:", forControlEvents: .EditingChanged)
        }
    }
    

    /*
    // MARK: - Navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "myPopover") {
            let popView = segue.destinationViewController as! AjudaPopoverController
            popView.popoverPresentationController!.delegate = self
            popView.txtLabel = "Como calcular porcentagem."
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    private func getLabel() -> UILabel {
        let label =  UILabel(frame: CGRectMake(20, 20, 50, 100))
        label.text = "text"
        return label
    }

}
