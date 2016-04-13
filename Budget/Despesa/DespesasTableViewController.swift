//
//  DespesasTableViewController.swift
//  Budget
//
//  Created by Yuri Pereira on 3/19/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

class DespesasTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var frc = Despesa.getReceitasController("data", secondSort: "nome", sectionName: "data")
    var despesaDAO:DespesaDAO = DespesaDAO()
    var categoria: Categoria?
    var conta: Conta?
    
    @IBOutlet var btnSidebar:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SidebarMenu.configMenu(self, sideBarMenu: btnSidebar)
        
        frc.delegate = self
        
        do{
            
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
            sections[section]
            
            let string = currentSection.name.substringWithRange(Range<String.Index>(start: currentSection.name.startIndex, end: currentSection.name.startIndex.advancedBy(10)))
            
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            let ddd = dateFormat.dateFromString(string)
            
            dateFormat.dateStyle = NSDateFormatterStyle.LongStyle
            dateFormat.timeStyle = NSDateFormatterStyle.NoStyle
            dateFormat.locale = NSLocale(localeIdentifier: "pt-BR")
            
            let dateString = dateFormat.stringFromDate(ddd!)
            
            return dateString
        }
        
        return nil
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: PlaceDespesaTableViewCell = tableView.dequeueReusableCellWithIdentifier("cellDespesa", forIndexPath: indexPath) as! PlaceDespesaTableViewCell
        
        let despesa = frc.objectAtIndexPath(indexPath) as! Despesa
        
        categoria = despesa.categoria
        conta = despesa.conta
        
        cell.lblNome.text = despesa.nome
        cell.lblValor.text = despesa.valor!.convertToCurrency("pt_BR")
        cell.lblCategoria.text = categoria?.nome
        cell.lblConta.text = conta?.nome
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        
        header.textLabel?.font = UIFont(name: "Futura", size: 13)!
        header.textLabel?.textColor = Color.uicolorFromHex(0xffffff)
        header.tintColor = Color.uicolorFromHex(0x274561)
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
            
            func removerDespesa(action:UIAlertAction) {
                
                let despesa:Despesa = frc.objectAtIndexPath(indexPath) as! Despesa
                
                do {
                    
                    try despesaDAO.remover(despesa)
                } catch {
                    
                    let alert = Notification.mostrarErro("Desculpe", mensagem: "Não foi possível remover")
                    presentViewController(alert, animated: true, completion: nil)
                }
            }
            
            let detalhes = Notification.solicitarConfirmacao("Excluir", mensagem: "Tem certeza que deseja excluir? \n O saldo da sua conta será atualizado!", completion: removerDespesa)
            presentViewController(detalhes, animated: true, completion: nil)
            
            atualizarTableView()
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "editar"{
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let contaController:DespesasViewController = segue.destinationViewController as! DespesasViewController
            let despesa: Despesa = frc.objectAtIndexPath(indexPath!) as! Despesa
            contaController.despesa = despesa
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - Delegate methods
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        atualizarTableView()
    }
    
    // MARK: - Private functions
    
    private func atualizarTableView(){
        tableView.reloadData()
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
}

