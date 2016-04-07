//
//  ValorInicialController.swift
//  Budget
//
//  Created by Calebe Santos on 4/7/16.
//  Copyright © 2016 Budget Company. All rights reserved.
//

import UIKit

class ValorInicialController: PorcentagemController {
    @IBAction func calcularValorInicial(sender: UIButton) {
        //Valor inicial com aumento
        calculadora?.numeroFinal = txtSegundoValor.text!.doubleConverterMoeda()
        
        if let calculadora = calculadora as? Porcentagem {
            calculadora.porcentagem = txtPrimeiroValor.text!.doubleValue
            
            if (sgmTipo.selectedSegmentIndex == 0) {
                lblResultado.text = calculadora.calcularValorInicialAumentado().convertToMoedaBr()
            } else {
                lblResultado.text = calculadora.calcularValorInicialDiminuido().convertToMoedaBr()
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if (segue.identifier == "myPopover") {
            let popView = segue.destinationViewController as! AjudaPopoverController
            popView.txtLabel = "Como calcular o valor inicial."
        }
    }
}