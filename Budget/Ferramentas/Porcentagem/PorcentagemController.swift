//
//  CalculadoraJurosController.swift
//  Budget
//
//  Created by Calebe Santos on 3/7/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit

class PorcentagemController: UITableViewController {

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
        FormCustomization.updateWidthsForLabels(labels)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func maskTextField(sender: UITextField) {
        FormCustomization.aplicarMascara(&sender.text!)
    }
    
    @IBAction func calcularValorPorcentagem(sender: UIButton) {
        //Porcentagem do valor
        if (sgmTipo.selectedSegmentIndex == 0) {
            calculadora?.numeroAtual = txtSegundoValor.text!.doubleConverterMoeda()
            if let calculadora = calculadora as? Porcentagem {
                calculadora.porcentagem = txtPrimeiroValor.text!.doubleConverter
                lblResultado.text = calculadora.calcularPorcentagemDoValor().convertToMoedaBr()
            }
        } else {
            calcularPercentualValor(sender)
        }
    }
    
    private func calcularPercentualValor(sender: UIButton) {
        //Valor porcentagem
        calculadora?.numeroAtual = txtPrimeiroValor.text!.doubleConverterMoeda()
        calculadora?.numeroFinal = txtSegundoValor.text!.doubleConverterMoeda()
        
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
