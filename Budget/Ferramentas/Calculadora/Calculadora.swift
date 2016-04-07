//
//  Calculadora.swift
//  Budget
//
//  Created by md10 on 3/3/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit

protocol tiposPermitidos {
    typealias Double
    typealias Float
}

class Calculadora {
    var numeroAtual:Double = 0
//    var segundoValor:Float = 0
    var numeroFinal:Double = 0
    var opcao:Int = 0
    
    func calcularOperacao() -> Double {
        switch(opcao){
            case 1:
                numeroFinal += numeroAtual
                break;
            case 2:
                numeroFinal -= numeroAtual
                break;
            case 3:
                numeroFinal /= numeroAtual
                break;
            case 4:
                numeroFinal *= numeroAtual
                break;
            default:
                break;
        }
        
        return numeroFinal
    }
    
    func limparCalculadora() {
        numeroAtual = 0
        numeroFinal = 0
        opcao = 0
    }
}
