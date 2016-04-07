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
        //Juros
        calculadora?.numeroAtual = txtSegundoValor.text!.doubleConverterMoeda()
        
        if let calculadora = calculadora as? Porcentagem {
            calculadora.porcentagem = txtPrimeiroValor.text!.doubleValue
            
            if (sgmTipo.selectedSegmentIndex == 0) {
                lblResultado.text = calculadora.calcularValorComJuros().convertToMoedaBr()
            } else {
                lblResultado.text = calculadora.calcularValorComDesconto().convertToMoedaBr()
            }
        }
        
        //Desconto
        //        calculadora?.numeroAtual = 1000
        //
        //        if let calculadora = calculadora as? Porcentagem {
        //            calculadora.porcentagem = 15
        //            print(calculadora.calcularValorComDesconto())
        //        }
    }
}