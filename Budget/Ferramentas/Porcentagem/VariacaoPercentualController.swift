//
//  VariacaoPercentual.swift
//  Budget
//
//  Created by Calebe Santos on 4/7/16.
//  Copyright © 2016 Budget Company. All rights reserved.
//

import UIKit

class VariacaoPercentualController: PorcentagemController {
    @IBAction func changePlaceholderVariacao(sender: UISegmentedControl) {
        if (sgmTipo.selectedSegmentIndex == 0) {
            txtSegundoValor.placeholder = "Valor aumentado"
        } else {
            txtSegundoValor.placeholder = "Valor reduzido"
        }
    }
    
    @IBAction func calcularVariacao(sender: UIButton) {
        //Aumento percentual
        calculadora?.numeroAtual = txtSegundoValor.text!.doubleConverterMoeda()
        calculadora?.numeroFinal = txtPrimeiroValor.text!.doubleConverterMoeda()
        
        if let calculadora = calculadora as? Porcentagem {
            if (calculadora.numeroFinal<=calculadora.numeroAtual) {
                lblResultado.text = String(format: "%.4g", calculadora.calcularAumentoPercentual()) + "%"
            } else {
                lblResultado.text = String(format: "%.4g", calculadora.calcularDiminuicaoPercentual()) + "%"
            }
        }
        //
        //        //Diminuição percentual
        //        calculadora?.numeroAtual = txtPrimeiroValor.text!.floatValue
        //        calculadora?.numeroFinal = txtSegundoValor.text!.floatValue
        //        if let calculadora = calculadora as? Porcentagem {
        //            print(calculadora.calcularDiminuicaoPercentual())
        //        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if (segue.identifier == "myPopover") {
            let popView = segue.destinationViewController as! AjudaPopoverController
            popView.txtLabel = "Como calcular a variação."
        }
    }

}
