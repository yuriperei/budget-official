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


/*========================================================================

let fetchRequest = NSFetchRequest(entityName: "Conta")
do {

    let results = try ContextFactory.getContext().executeFetchRequest(fetchRequest)

    for result in results {
        total += result.valueForKey("saldo")! as! Float
    }

} catch {
    print(error)
}

let currentDate = NSDate()
let currentMonth = NSCalendar.currentCalendar().components([.Month], fromDate: currentDate)

let currentYear = NSCalendar.currentCalendar().components([.Year], fromDate: NSDate())

let calendar = NSCalendar.currentCalendar()
let newDate = calendar.dateFromComponents(currentYear)

var total:Float = 0.0
let fetchRequest = NSFetchRequest(entityName: "Receita")
do {

    let results = try ContextFactory.getContext().executeFetchRequest(fetchRequest)

    for result in results {
        total += result.valueForKey("valor")! as! Float
    }

} catch {
    print(error)
}

var total:Float = 0.0
let fetchRequest = NSFetchRequest(entityName: "Despesa")
do {

    let results = try ContextFactory.getContext().executeFetchRequest(fetchRequest)

    for result in results {
        total += result.valueForKey("valor")! as! Float
    }

} catch {
    print(error)
}

var firstDay:NSDate?
var lastDay:NSDate?

do{
        firstDay = newDate?.dateByAddingMonths(i)!.startOfMonth()
        lastDay = newDate?.dateByAddingMonths(i)!.endOfMonth()

        let predicate = NSPredicate(format: "(data>=%@) and (data<=%@)", firstDay!, lastDay!)
        fetchRequest.predicate = predicate

        let results = try ContextFactory.getContext().executeFetchRequest(fetchRequest)
}catch{
    print(error)
}

var fetchRequest = NSFetchRequest(entityName: "Categoria")
var total:Double = 0
var despesasPorCategoria:[Double] = []
var categorias:[String]?
do {
    let cats = try ContextFactory.getContext().executeFetchRequest(fetchRequest)
    categorias = cats.map({cat in cat.valueForKey("nome") as! String})
    fetchRequest = NSFetchRequest(entityName: "Despesa")

    for categoria in categorias! {
        let predicate = NSPredicate(format:"categoria.nome = %@", categoria)
        fetchRequest.predicate = predicate

        let results = try ContextFactory.getContext().executeFetchRequest(fetchRequest)

        let valores = results.map({result in result.valueForKey("valor") as! Double})

        total = round(100*valores.reduce(0.0,combine: +))/100

        despesasPorCategoria.append(total)
    }
} catch {
    print(error)
}

return (categorias!, despesasPorCategoria)

var fetchRequest = NSFetchRequest(entityName: "Categoria")
var total:Double = 0
var receitasPorCategoria:[Double] = []
var categorias:[String]?
do {
let cats = try ContextFactory.getContext().executeFetchRequest(fetchRequest)
categorias = cats.map({cat in cat.valueForKey("nome") as! String})
fetchRequest = NSFetchRequest(entityName: "Receita")

for categoria in categorias! {
let predicate = NSPredicate(format:"categoria.nome = %@", categoria)
fetchRequest.predicate = predicate

let results = try ContextFactory.getContext().executeFetchRequest(fetchRequest)

let valores = results.map({result in result.valueForKey("valor") as! Double})

total = round(100*valores.reduce(0.0,combine: +))/100

receitasPorCategoria.append(total)
}
} catch {
print(error)
}

return (categorias!, receitasPorCategoria)

//Map() - cria um novo array com valores vindos do array de receitas do mês
//Round() - usado para arrendondar o valor para duas casas decimais
//Reduce() - usado para somar os valores dentro do novo array vindo do map()


//    private func getListMonth() -> [String] {
//        return ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez"]
//    }
//let months = getListMonth()

==========================================================================*/
