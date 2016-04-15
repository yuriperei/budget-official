//
//  ReceitasTableViewController.swift
//  Budget
//
//  Created by Yuri Pereira on 3/16/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

class ReceitasTableViewController: UITableViewController, NSFetchedResultsControllerDelegate{

    let receitaDAO = ReceitaDAO()
    
    var categoria: Categoria?
    var conta: Conta?
    var frc = Receita.getReceitasController("data", secondSort: "nome", sectionName: "data")
    
    @IBOutlet var btnSidebar:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frc.delegate = self
        SidebarMenu.configMenu(self, sideBarMenu: btnSidebar)
        
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
        
        if let sections = frc.sections {
            return sections.count
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = frc.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if let sections = frc.sections {
            let currentSection = sections[section]
            return Data.sectionFormatarData(currentSection.name)
        }
        
        return nil
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: PlaceReceitaTableViewCell = tableView.dequeueReusableCellWithIdentifier("cellReceita", forIndexPath: indexPath) as! PlaceReceitaTableViewCell
        
        let receita = frc.objectAtIndexPath(indexPath) as! Receita
        
        categoria = receita.categoria
        conta = receita.conta
        
        cell.lblNome.text = receita.nome
        cell.lblValor.text = receita.valor?.convertToCurrency("pt_BR")
        cell.lblConta.text = conta?.nome
        cell.lblCategoria.text = categoria?.nome
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel!.font = UIFont(name: "Futura", size: 13)!
        header.textLabel!.textColor = Color.uicolorFromHex(0xffffff)
        header.tintColor = Color.uicolorFromHex(0x274561)
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
            
            let detalhes = Notification.solicitarConfirmacao("Excluir", mensagem: "Tem certeza que deseja excluir?", completion:{
                (action:UIAlertAction) in
                do{
                    let receita:Receita = self.frc.objectAtIndexPath(indexPath) as! Receita
                    try self.receitaDAO.remover(receita)
                } catch {
                    let alert = Notification.mostrarErro("Desculpe", mensagem: "Não foi possível remover")
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
            
            presentViewController(detalhes, animated: true, completion: nil)
            atualizarTableView()
            
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "editar" {
            
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let contaController : ReceitasViewController = segue.destinationViewController as! ReceitasViewController
            let receita: Receita = frc.objectAtIndexPath(indexPath!) as! Receita
            contaController.receita = receita
        }
    }
    
    // MARK: - Delegate methods
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        atualizarTableView()
    }
    
    // MARK: - Private functions
    
    private func atualizarTableView() {
        
        tableView.reloadData()
    }
    
}