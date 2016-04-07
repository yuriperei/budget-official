//
//  Porcentagem.swift
//  Budget
//
//  Created by Calebe Santos on 3/7/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import Foundation

class Porcentagem : Calculadora {
    var porcentagem: Double = 0
    
    override init() {
        super.init()
        self.opcao = 4
    }

    func calcularPorcentagemDoValor() -> Double {
        self.numeroFinal = porcentagem/100
        
        return self.calcularOperacao()
    }
    
    func calcularValorComDesconto() -> Double {
        self.porcentagem /= 100
        self.numeroFinal = 1 - porcentagem
        return self.calcularOperacao()
    }
    
    func calcularValorComJuros() -> Double {
        self.porcentagem /= 100
        self.numeroFinal = 1 + porcentagem
        return self.calcularOperacao()
    }
    
    func calcularValorPorcentagem() -> Double {
        self.numeroFinal = self.numeroAtual/self.numeroFinal
        self.numeroAtual = 100
        return self.calcularOperacao()
    }
    
    func calcularAumentoPercentual() -> Double {
        return self.calcularValorPorcentagem() - 100
    }
    
    func calcularDiminuicaoPercentual() -> Double {
        return 100 - self.calcularValorPorcentagem()
    }
    
    func calcularValorInicialAumentado() -> Double {
        //numeroFinal = 1200
        //porcentagem = 20
        self.porcentagem += 100
        self.numeroFinal /= self.porcentagem
        self.numeroAtual = 100
        return self.calcularOperacao()
    }
    
    func calcularValorInicialDiminuido() -> Double {
        self.porcentagem = 100 - self.porcentagem
        self.numeroFinal /= self.porcentagem
        self.numeroAtual = 100
        return self.calcularOperacao()
    }
}