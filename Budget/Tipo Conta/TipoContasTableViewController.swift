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

//    @IBOutlet var btnSidebar:UIBarButtonItem!
    var tela:Bool = false
    
    weak var delegate: TipoContasViewControllerDelegate?
    var tipoContaDAO: TipoContaDAO = TipoContaDAO()
    
//    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var frc = TipoConta.getTipoContasController("nome")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frc.delegate = self
        
        if tela == false{
            let btnSidebar = UIBarButtonItem(image: UIImage(named: "interface.png"), style: .Done, target: self, action: nil)
            
            self.navigationItem.setLeftBarButtonItem(btnSidebar, animated: false)
            SidebarMenu.configMenu(self, sideBarMenu: btnSidebar)
        
        }

        
        do{
            try frc.performFetch()
        }catch{
            let alerta = Notification.mostrarErro()
            presentViewController(alerta, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    // MARK: - Core Data source
//    func tipoContasFetchRequest() -> NSFetchRequest{
//        let fetchRequest = NSFetchRequest(entityName: "TipoConta")
//        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        return fetchRequest
//    }
//    
//    func getFetchedResultsController() -> NSFetchedResultsController {
//        
//        frc = NSFetchedResultsController(fetchRequest: tipoContasFetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//        return frc
//    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        atualizarTableView()
    }
    
    func atualizarTableView(){
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        let numbersOfSections = frc.sections?.count
        return numbersOfSections!
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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

        // Configure the cell...
        let tipoConta = frc.objectAtIndexPath(indexPath) as! TipoConta
        cell.textLabel?.text = tipoConta.nome
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if (indexPath.row % 2 == 0){
            cell.backgroundColor = Color.uicolorFromHex(0xf9f9f9)
        }else{
            cell.backgroundColor = Color.uicolorFromHex(0xffffff)
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
           
            let tipoConta = frc.objectAtIndexPath(indexPath) as! TipoConta
            
            // Método para ser chamado ao deletar item
            func removerSelecionado(action:UIAlertAction){
                do{
                    try tipoContaDAO.remover(tipoConta)
                }catch{
                    presentViewController(Notification.mostrarErro(), animated: true, completion: nil)
                }
            }
            
            // Verifica se tem alguma conta associada, se não tiver permite deletarß
            if (tipoConta.conta?.count > 0){
                let alerta = Notification.mostrarErro("Desculpe", mensagem: "Você não pode deletar porque há uma ou mais contas associadas.")
                presentViewController(alerta, animated: true, completion: nil)
            }else{
                
                let detalhes = Notification.solicitarConfirmacao("Deletar", mensagem: "Tem certeza que deseja deletar?", completion:removerSelecionado)
                presentViewController(detalhes, animated: true, completion: nil)
                atualizarTableView()
            }
            
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }


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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//
//        if segue.identifier == "editar"{
//            let cell = sender as! UITableViewCell
//            let indexPath = tableView.indexPathForCell(cell)
//            let contaController : TipoContaViewController = segue.destinationViewController as! TipoContaViewController
//            let tipoConta: TipoConta = frc.objectAtIndexPath(indexPath!) as! TipoConta
//            contaController.tipoConta = tipoConta
//        }
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }

}
