//
//  ValorInicialController.swift
//  Budget
//
//  Created by Calebe Santos on 4/7/16.
//  Copyright © 2016 Budget Company. All rights reserved.
//

import UIKit

class ValorInicialController: PorcentagemController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if (segue.identifier == "myPopover") {
            let popView = segue.destinationViewController as! AjudaPopoverController
            popView.txtLabel = "Cálculo para encontrar um valor original antes de um juros ou desconto ser aplicado.\n- Primeiro: Insira o valor com o juros ou desconto aplicado;\n- Segundo: Insira a porcentagem aplicada sobre o primeiro valor;\n- Terceiro: Escolha se a porcentagem aplicada é um juros ou desconto;"
            popView.preferredContentSize = CGSize(width: 300, height: 300)
        }
    }
    
    // MARK: - IBAction functions
    
    @IBAction func calcularValorInicial(sender: UIButton) {
        
        calculadora?.numeroFinal = txtSegundoValor.text!.currencyToDouble()
        
        if let calculadora = calculadora as? Porcentagem {
            calculadora.porcentagem = txtPrimeiroValor.text!.doubleValue
            
            if (sgmTipo.selectedSegmentIndex == 0) {
                lblResultado.text = calculadora.calcularValorInicialAumentado().convertToCurrency("pt_BR")
            } else {
                lblResultado.text = calculadora.calcularValorInicialDiminuido().convertToCurrency("pt_BR")
            }
        }
    }
}