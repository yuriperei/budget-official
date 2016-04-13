//
//  Dashboard.swift
//  Budget
//
//  Created by md10 on 3/18/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

class Dashboard {
    
    private let months = ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez"]
    
    // MARK: - Public functions
    
    func getSaldoTotal() -> Float {
        
        let saldo:[Float] = ContaDAO().getListaContas().map({conta in conta.saldo as! Float})
        
        return saldo.reduce(0.0, combine:+)
    }
    
    func getTotalReceitas() -> Float {
        
        let month = getCurrentDate().month
        let year = getCurrentDate().year
        
        let receitasDoMes = ReceitaDAO().getReceitasFromMonth(month, year: year)
        let saldo:[Float] = receitasDoMes.map({receita in receita.valor as! Float})
        
        return saldo.reduce(0.0, combine: +)
    }
    
    func getTotalDespesas() -> Float {
        
        let month = getCurrentDate().month
        let year = getCurrentDate().year
        
        let despesasDoMes = DespesaDAO().getDespesasFromMonth(month, year: year)
        let saldo:[Float] = despesasDoMes.map({despesa in despesa.valor as! Float})
        
        return saldo.reduce(0.0, combine: +)
    }
    
    func getBalancoAnual() -> (Array<String>,[Double], [Double]) {
        
        var receitasMensal:[Double] = []
        var despesasMensal:[Double] = []
        
        let year = getCurrentDate().year
        
        let receitaDAO:ReceitaDAO = ReceitaDAO()
        let despesaDAO:DespesaDAO = DespesaDAO()
        
        // Estrutura de repetição para pegar o somatório de receitas e despesas do primeiro mês até o mês atual
        for i in 1...getCurrentDate().month {
            
            let receitas = receitaDAO.getReceitasFromMonth(i, year: year)
            let totalReceitas:Double = receitas.map({receita in receita.valor as! Double}).reduce(0.0, combine: +)
            receitasMensal.append(totalReceitas)
            
            let despesas = despesaDAO.getDespesasFromMonth(i, year: year)
            let totalDespesas:Double = despesas.map({despesa in despesa.valor as! Double}).reduce(0.0, combine: +)
            despesasMensal.append(totalDespesas)
        }
        
        return (Array(months[0..<getCurrentDate().month]), receitasMensal, despesasMensal)
    }
    
    func getDespesasPorCategoria() -> ([String],[Double]) {
        
        let month = getCurrentDate().month
        let year = getCurrentDate().year
        
        let listaDespesas = DespesaDAO().getDespesasFromMonth(month, year: year)
        let categorias = CategoriaDAO().getListaCategorias()
        
        var categoriasDespesas:[String] = []
        var totalDespesasCategoria:[Double] = []
        
        for categoria in categorias {
            
            let despesas = listaDespesas.filter({ despesa in despesa.categoria?.nome == categoria.nome })
            let valor = despesas.map({despesa in despesa.valor as! Double}).reduce(0, combine: +)
            
            // Verificação para pegar apenas categorias com despesas
            if(valor > 0){
                totalDespesasCategoria.append(valor)
                categoriasDespesas.append(categoria.nome!)
            }
        }
        
        return (categoriasDespesas,totalDespesasCategoria)
    }
    
    func getReceitasPorCategoria() -> ([String],[Double]) {
        
        let month = getCurrentDate().month
        let year = getCurrentDate().year
        
        let receitas = ReceitaDAO().getReceitasFromMonth(month, year: year)
        let categorias = CategoriaDAO().getListaCategorias()
        
        var categoriasReceitas:[String] = []
        var totalReceitasCategoria:[Double] = []
        
        for categoria in categorias {
            
            let receitas = receitas.filter({ receita in receita.categoria?.nome == categoria.nome })
            let valor = receitas.map({receita in receita.valor as! Double}).reduce(0, combine: +)
            
            // Verificação para pegar apenas categorias com receitas
            if(valor > 0){
                totalReceitasCategoria.append(valor)
                categoriasReceitas.append(categoria.nome!)
            }
        }
        
        return (categoriasReceitas,totalReceitasCategoria)
    }
    
    //MARK: - Private functions
    
    private func getCurrentDate() -> NSDateComponents {
        return NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: NSDate())
    }
    
}