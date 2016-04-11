//
//  FinanceFactory.swift
//  Budget
//
//  Created by Calebe Santos on 3/18/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import Foundation
import JavaScriptCore

class Finance {
    let context:JSContext!
    
    init(){
        
        context = JSContext()
        
        do {
            
            let path = NSBundle.mainBundle().pathForResource("finance", ofType: "js")
            let url = NSURL(fileURLWithPath: path!)
            let jscript = try String.init(contentsOfURL: url)
            
            context.evaluateScript(jscript)
            context.evaluateScript("var finance = new Finance();")
        } catch {
            print(error)
        }
    }
    
    func calculateCompoundInterest(valorAVista: Double, _ numeroDeParcelas: Int, _ valorDaParcela: Double) -> Double {
        
        var taxaDeJuros = 0.005;
        var qtdTaxasIguais = 0.0;
        var taxaDeJurosNova = 0.0;
        var i = 0;
        
        while(qtdTaxasIguais < 35) {
            // Fórmula para calcular novo juros -
            taxaDeJurosNova = (valorDaParcela/valorAVista) * (1-pow(Double(1+taxaDeJuros),Double(-numeroDeParcelas)))
            
            let x = taxaDeJurosNova.roundDecimal(6)
            let y = taxaDeJuros.roundDecimal(6)
            print(x)
            if(x == y){
                qtdTaxasIguais++
            } else {
                qtdTaxasIguais = 0
            }
            i++
            taxaDeJuros = taxaDeJurosNova
        }
        
        taxaDeJuros *= 100
        print(taxaDeJuros.roundDecimal(2))
        
        return taxaDeJuros.roundDecimal(2)
    }
    
    func calculateFutureValue(taxaJuros:Float, valorDepositado:Double, numeroDeParcelas:Int) -> Double {
        
        let script = "finance.FV(\(taxaJuros),\(valorDepositado),\(numeroDeParcelas));"
        return context.evaluateScript(script).toDouble()
    }
}