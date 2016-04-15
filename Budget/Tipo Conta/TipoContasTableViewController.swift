//
//  TipoContaTableViewController.swift
//  Budget
//
//  Created by Calebe Santos on 3/10/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

class TipoContasTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var tela:Bool = false
    var delegate: TipoContasViewControllerDelegate?
    var tipoContaDAO: TipoContaDAO = TipoContaDAO()
    var frc = TipoConta.getTipoContasController("nome")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frc.delegate = self
        
        if tela == false {
            
            let btnSidebar = UIBarButtonItem(image: UIImage(named: "interface.png"), style: .Done, target: self, action: nil)
            
            self.navigationItem.setLeftBarButtonItem(btnSidebar, animated: false)
            SidebarMenu.configMenu(self, sideBarMenu: btnSidebar)
        }
        
        do {
            
            try frc.performFetch()
        } catch {
            
            let alerta = Notification.mostrarErro()
            presentViewController(alerta, animated: true, completion: nil)
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let tipoConta = frc.objectAtIndexPath(indexPath) as! TipoConta
        
        delegate?.tipoContasViewControllerResponse(tipoConta)
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellTipoConta", forIndexPath: indexPath)
        
        let tipoConta = frc.objectAtIndexPath(indexPath) as! TipoConta
        cell.textLabel?.text = tipoConta.nome
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.row % 2 == 0) {
            
            cell.backgroundColor = Color.uicolorFromHex(0xf9f9f9)
        } else {
            
            cell.backgroundColor = Color.uicolorFromHex(0xffffff)
        }
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let tipoConta = frc.objectAtIndexPath(indexPath) as! TipoConta
            
            func removerSelecionado(action:UIAlertAction){
                do{
                    try tipoContaDAO.remover(tipoConta)
                }catch{
                    presentViewController(Notification.mostrarErro(), animated: true, completion: nil)
                }
            }
            
            // Verifica se tem alguma conta associada
            if (tipoConta.conta?.count > 0) {
                
                let alerta = Notification.mostrarErro("Desculpe", mensagem: "Você não pode deletar porque há uma ou mais contas associadas.")
                presentViewController(alerta, animated: true, completion: nil)
                
            // Se não tiver permite deletar
            } else {
                
                let detalhes = Notification.solicitarConfirmacao("Deletar", mensagem: "Tem certeza que deseja deletar?", completion:removerSelecionado)
                presentViewController(detalhes, animated: true, completion: nil)
                atualizarTableView()
            }
        }
    }
    
    // MARK: - Delegate methods
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        atualizarTableView()
    }
    
    // MARK: - Private functions
    
    func atualizarTableView(){
        tableView.reloadData()
    }

}