//
//  LocalTableViewController.swift
//  Budget
//
//  Created by Yuri Pereira on 4/1/16.
//  Copyright © 2016 Budget Company. All rights reserved.
//

import UIKit
import CoreData

class LocalTableViewController: UITableViewController, NSFetchedResultsControllerDelegate{
    
    let localDAO = LocalDAO()
    
    var delegate: LocalViewControllerDelegate?
    var tela:Bool = false
    var frc = Local.getLocaisController("nome")
    
    @IBOutlet var btnSideBar:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        frc = Local.getLocaisController("nome")
        frc.delegate = self
        
        if let sidebar = btnSideBar {
            SidebarMenu.configMenu(self, sideBarMenu: sidebar)
        }
        
        do{
            try frc.performFetch()
        }catch{
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
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.row % 2 == 0){
            cell.backgroundColor = Color.uicolorFromHex(0xf9f9f9)
        }else{
            cell.backgroundColor = Color.uicolorFromHex(0xffffff)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: PlaceLocalTableViewCell = tableView.dequeueReusableCellWithIdentifier("cellLocal", forIndexPath: indexPath) as! PlaceLocalTableViewCell
        
        let local = frc.objectAtIndexPath(indexPath) as! Local
        cell.lblNome.text = local.nome
        cell.lblEndereco.text = local.rua! + " - " + local.cidade! + " - " + local.estado!
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let local = frc.objectAtIndexPath(indexPath) as! Local
            
            // Método para ser chamado ao deletar item
            func removerSelecionado(action:UIAlertAction){
                do{
                    try localDAO.remover(local)
                }catch{
                    presentViewController(Notification.mostrarErro(), animated: true, completion: nil)
                }
            }
            
            // Verifica se tem alguma despesa ou receita associada, se não tiver permite deletar
            if (local.despesa?.count > 0) {
                
                let alerta = Notification.mostrarErro("Desculpe", mensagem: "Você não pode deletar porque há uma ou mais despesas associadas.")
                presentViewController(alerta, animated: true, completion: nil)

            } else if (local.receita?.count > 0) {
                
                let alerta = Notification.mostrarErro("Desculpe", mensagem: "Você não pode deletar porque há uma ou mais receitas associadas.")
                presentViewController(alerta, animated: true, completion: nil)
            
            } else {
                
                let detalhes = Notification.solicitarConfirmacao("Deletar", mensagem: "Tem certeza que deseja deletar?", completion:removerSelecionado)
                presentViewController(detalhes, animated: true, completion: nil)
                atualizarTableView()
                
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let local = frc.objectAtIndexPath(indexPath) as! Local
        delegate?.localViewControllerResponse(local)
        
        if tela == true{
            navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "editar"{
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let contaController : LocalViewController = segue.destinationViewController as! LocalViewController
            let local: Local = frc.objectAtIndexPath(indexPath!) as! Local
            contaController.local = local
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    // MARK: - Delegate methods

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        atualizarTableView()
    }
    
    // MARK: - Private Functions
    
    private func atualizarTableView(){
        tableView.reloadData()
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
}