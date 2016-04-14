//
//  VariacaoPercentual.swift
//  Budget
//
//  Created by Calebe Santos on 4/7/16.
//  Copyright © 2016 Budget Company. All rights reserved.
//

import UIKit

class VariacaoPercentualController: PorcentagemController {
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if (segue.identifier == "myPopover") {
            let popView = segue.destinationViewController as! AjudaPopoverController
            popView.txtLabel = "Cálculo para encontrar a diferença, em porcentagem, entre dois valores\n- Primeiro: Insira o valor original, ou seja, o valor antes de qualquer modificação;\n- Segundo: Insira o valor que sofreu alguma modificação;"
        }
    }
    
    // MARK: - IBActions functions
    
    @IBAction func changePlaceholderVariacao(sender: UISegmentedControl) {
        if (sgmTipo.selectedSegmentIndex == 0) {
            txtSegundoValor.placeholder = "Valor aumentado"
        } else {
            txtSegundoValor.placeholder = "Valor reduzido"
        }
    }
    
    @IBAction func calcularVariacao(sender: UIButton) {
        //Aumento percentual
        calculadora?.numeroAtual = txtSegundoValor.text!.currencyToDouble()
        calculadora?.numeroFinal = txtPrimeiroValor.text!.currencyToDouble()
        
        if let calculadora = calculadora as? Porcentagem {
            if (calculadora.numeroFinal<=calculadora.numeroAtual) {
                lblResultado.text = String(format: "%.4g", calculadora.calcularAumentoPercentual()) + "%"
            } else {
                lblResultado.text = String(format: "%.4g", calculadora.calcularDiminuicaoPercentual()) + "%"
            }
        }
    }
}

/*
Comentários temporários
//
//        //Diminuição percentual
//        calculadora?.numeroAtual = txtPrimeiroValor.text!.floatValue
//        calculadora?.numeroFinal = txtSegundoValor.text!.floatValue
//        if let calculadora = calculadora as? Porcentagem {
//            print(calculadora.calcularDiminuicaoPercentual())
//        }
*/