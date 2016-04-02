//
//  LocalTableViewController.swift
//  Budget
//
//  Created by Yuri Pereira on 4/1/16.
//  Copyright © 2016 Budget Company. All rights reserved.
//

import UIKit
import CoreData

protocol LocalViewControllerDelegate: class {
    func localViewControllerResponse(local:Local)
}

class LocalTableViewController: UITableViewController, NSFetchedResultsControllerDelegate{
    
    weak var delegate: LocalViewControllerDelegate?
    var tela:Bool = false
    
    var frc = NSFetchedResultsController()
    let localDAO = LocalDAO()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        frc = Local.getLocaisController("nome")
        frc.delegate = self
        
        do{
            try frc.performFetch()
        }catch{
            let alert = Notification.mostrarErro()
            presentViewController(alert, animated: true, completion: nil)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        if let sections = frc.sections {
            return sections.count
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if let sections = frc.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: PlaceLocalTableViewCell = tableView.dequeueReusableCellWithIdentifier("cellLocal", forIndexPath: indexPath) as! PlaceLocalTableViewCell
        
        // Configure the cell...
        let local = frc.objectAtIndexPath(indexPath) as! Local
        cell.lblNome.text = local.nome
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let detalhes = Notification.solicitarConfirmacao("Excluir", mensagem: "Tem certeza que deseja excluir?", completion:{
                (action:UIAlertAction) in
                do{
                    let local:Local = self.frc.objectAtIndexPath(indexPath) as! Local
                    try self.localDAO.remover(local)
                } catch {
                    let alert = Notification.mostrarErro("Desculpe", mensagem: "Não foi possível remover")
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
            
            presentViewController(detalhes, animated: true, completion: nil)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let local = frc.objectAtIndexPath(indexPath) as! Local
        delegate?.localViewControllerResponse(local)
        
        if tela == true{
            navigationController?.popViewControllerAnimated(true)
        }
        
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

}
