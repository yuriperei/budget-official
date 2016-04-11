//
//  JurosDescontos.swift
//  Budget
//
//  Created by Calebe Santos on 4/7/16.
//  Copyright © 2016 Budget Company. All rights reserved.
//

import UIKit

class JurosDescontosController: PorcentagemController {
    
    @IBAction func calcularJurosDescontos(sender: UIButton) {
        
        calculadora?.numeroAtual = txtSegundoValor.text!.currencyToDouble()
        
        if let calculadora = calculadora as? Porcentagem {
            calculadora.porcentagem = txtPrimeiroValor.text!.doubleValue
            
            if (sgmTipo.selectedSegmentIndex == 0) {
                lblResultado.text = calculadora.calcularValorComJuros().convertToCurrency("pt_BR")
            } else {
                lblResultado.text = calculadora.calcularValorComDesconto().convertToCurrency("pt_BR")
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        super.prepareForSegue(segue, sender: sender)
        
        if (segue.identifier == "myPopover") {
            let popView = segue.destinationViewController as! AjudaPopoverController
            popView.txtLabel = "Como calcular o juros e descontos."
        }
    }
}

/*
Comentários temporários
//Desconto
//        calculadora?.numeroAtual = 1000
//
//        if let calculadora = calculadora as? Porcentagem {
//            calculadora.porcentagem = 15
//            print(calculadora.calcularValorComDesconto())
//        }
*/