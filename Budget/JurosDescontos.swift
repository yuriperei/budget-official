//
//  JurosDescontos.swift
//  Budget
//
//  Created by Calebe Santos on 4/7/16.
//  Copyright © 2016 Budget Company. All rights reserved.
//

import UIKit

class JurosDescontosController: PorcentagemController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        super.prepareForSegue(segue, sender: sender)
        
        if (segue.identifier == "myPopover") {
            let popView = segue.destinationViewController as! AjudaPopoverController
            popView.txtLabel = "Cálculo para encontrar o novo valor obtido de um juros ou desconto aplicado\n- Primeiro: Insira o valor que será aplicado o juros ou desconto;\n- Segundo: Insira a porcentagem a ser aplicada sobre o primeiro valor;\n- Terceiro: Escolha o tipo da porcentagem aplicada, se será um juros ou desconto;"
            popView.preferredContentSize = CGSize(width: 300, height: 300)
        }
    }
    
    // MARK: IBAction functions
    
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