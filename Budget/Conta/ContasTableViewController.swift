//
//  ContasTableViewController.swift
//  Budget
//
//  Created by Calebe Santos on 3/10/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

class ContasTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    let contaDAO:ContaDAO = ContaDAO()
    let context = ContextFactory.getContext()
    
    
    var tela: Bool = false // Variável para verificar se está vindo da tela ReceitaViewController
    var delegate: ContasViewControllerDelegate?
    var frc = Conta.getContasController("nome")
    
    @IBOutlet var btnSidebar:UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let sidebar = btnSidebar {
            
            SidebarMenu.configMenu(self, sideBarMenu: sidebar)
        }
        
        frc.delegate = self
        
        do {
            
            try frc.performFetch()
        } catch {
            
            let alert = Notification.mostrarErro()
            presentViewController(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        let numbersOfSections = frc.sections?.count
        return numbersOfSections!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let numberOfRowsInSection = frc.sections?[section].numberOfObjects
        return numberOfRowsInSection!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: PlaceContaTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PlaceContaTableViewCell
        
        let conta = frc.objectAtIndexPath(indexPath) as! Conta
        
        cell.lblConta?.text = conta.nome
        cell.lblTipConta.text = String((conta.tipoconta?.nome)!)
        cell.lblSaldo.text = conta.saldo!.convertToCurrency("pt_BR")
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.row % 2 == 0){
            cell.backgroundColor = Color.uicolorFromHex(0xf9f9f9)
        }else{
            cell.backgroundColor = Color.uicolorFromHex(0xffffff)
        }
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let conta = frc.objectAtIndexPath(indexPath) as! Conta
            
            func removerSelecionado(action:UIAlertAction){
                do{
                    try contaDAO.remover(conta)
                }catch{
                    presentViewController(Notification.mostrarErro(), animated: true, completion: nil)
                }
            }
            
            // Verifica se tem alguma receita associada
            if (conta.receita?.count > 0) {
                
                let alerta = Notification.mostrarErro("Desculpe", mensagem: "Você não pode deletar porque há uma ou mais receitas associadas.")
                presentViewController(alerta, animated: true, completion: nil)
                
            // Verifica se tem alguma despesa associada
            } else if(conta.despesa?.count > 0) {
                
                let alerta = Notification.mostrarErro("Desculpe", mensagem: "Você não pode deletar porque há uma ou mais despesas associadas.")
                presentViewController(alerta, animated: true, completion: nil)
                
            // Se não tiver permite deletar
            } else {
                
                let detalhes = Notification.solicitarConfirmacao("Deletar", mensagem: "Tem certeza que deseja deletar?", completion:removerSelecionado)
                presentViewController(detalhes, animated: true, completion: nil)
                atualizarTableView()
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let conta = frc.objectAtIndexPath(indexPath) as! Conta
        delegate?.contasViewControllerResponse(conta)
        
        if tela == true {
            
            navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "editar" {
            
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let contaController : ContasViewController = segue.destinationViewController as! ContasViewController
            let conta: Conta = frc.objectAtIndexPath(indexPath!) as! Conta
            
            contaController.conta = conta
        }
    }
    
    // MARK: - Delegate methods
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        atualizarTableView()
    }
    
    // MARK: - Private functions
    
    func atualizarTableView() {
        
        tableView.reloadData()
    }

}
