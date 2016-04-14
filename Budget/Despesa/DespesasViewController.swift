//
//  DespesasViewController.swift
//  Budget
//
//  Created by md10 on 3/23/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

class DespesasViewController: UITableViewController, ContasViewControllerDelegate, CategoriaViewControllerDelegate, LocalViewControllerDelegate, UIGestureRecognizerDelegate  {
    
    var erros: String = ""
    var conta: Conta? = nil
    var categoria: Categoria? = nil
    var despesa: Despesa?
    var local: Local? = nil
    var despesaDAO: DespesaDAO = DespesaDAO()
    var pickerView: UIDatePicker!
    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtDescricao: UITextField!
    @IBOutlet weak var navegacao: UINavigationItem!
    @IBOutlet weak var txtValor: UITextField!
    @IBOutlet weak var txtEndereco: UITextField!
    @IBOutlet weak var txtConta: UITextField!
    @IBOutlet weak var txtCategoria: UITextField!
    @IBOutlet weak var sgFglTipo: UISegmentedControl!
    @IBOutlet weak var txtData: UITextField!
    
    @IBOutlet var textViews:[UITextField]!
    
    // MARK: - Private Functions
    
    private func addDismissInputView() {
        let tap = UITapGestureRecognizer(target: self, action: Selector("dismiss:"))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    // MARK: - Selector Functions
    
    func dismiss(sender: UITapGestureRecognizer? = nil) {
        FormCustomization.dismissInputView(textViews)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView = UIDatePicker()
        pickerView.datePickerMode = UIDatePickerMode.Date
        pickerView.addTarget(self, action: "updateTextField:", forControlEvents: .ValueChanged)
        
        if let despesa = despesa {
            txtNome.text = despesa.nome!
            txtValor.text = despesa.valor!.convertToCurrency("pt_BR")
            txtDescricao.text = despesa.descricao!
            conta = despesa.conta
            txtData.text = Data.formatDateToString(despesa.data!)
            categoria = despesa.categoria
            local = despesa.local
            
            sgFglTipo.selectedSegmentIndex = Int(despesa.flgTipo!)!
            
            txtValor.enabled = false
            txtData.enabled = false
            txtConta.enabled = false
        } else {
            txtData.text = Data.formatDateToString(pickerView.date)
        }
        
        txtConta.text = self.conta?.nome!
        txtCategoria.text = self.categoria?.nome!
        txtEndereco.text = self.local?.nome
        txtData.inputView = pickerView
        
        FormCustomization.alignLabelsWidths(labels)
        addDismissInputView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch(section) {
        case 0: return 5    // section 0 has 2 rows
        case 1: return 1    // section 1 has 1 row
        case 2: return 1    // section 2 has 1 row
        case 3: return 1    // section 3 has 1 row
        default: fatalError("Unknown number of sections")
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        FormCustomization.dismissInputView([txtNome, txtValor, txtDescricao, txtData])
        
        if segue.identifier == "alterarConta" {
            
            let contasController : ContasTableViewController = segue.destinationViewController as! ContasTableViewController
            contasController.delegate = self
            contasController.tela = true
            
        } else if segue.identifier == "alterarCategoriaDespesa" {
            
            let categoriasController : CategoriaTableViewController = segue.destinationViewController as! CategoriaTableViewController
            categoriasController.delegate = self
            categoriasController.tela = true
            
        } else if segue.identifier == "alterarLocalDespesa" {
            
            let locaisController : LocalTableViewController = segue.destinationViewController as! LocalTableViewController
            locaisController.delegate = self
            locaisController.tela = true
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        if despesa == nil {
            return true
        }
        
        if identifier == "alterarCategoriaDespesa"{
            return true
        }
        
        if identifier == "alterarLocalDespesa"{
            return true
        }
        
        return false
    }
    
    // MARK: - IBAction functions
    
    @IBAction func btnCancel(sender: AnyObject) {
        dissmissViewController()
    }
    
    
    @IBAction func btnSave(sender: AnyObject) {
        
        if despesa != nil {
            updateConta()
        }else{
            addConta()
        }
    }
    
    @IBAction func indexChanged(sender:UISegmentedControl){
        switch sgFglTipo.selectedSegmentIndex{
        case 0:
            despesa?.flgTipo = "0"; // Fixa
        case 1:
            despesa?.flgTipo = "1"; // Variável
        case 2:
            despesa?.flgTipo = "2" // Adicional
        default:
            break;
        }
        
    }
    
    @IBAction func maskTextField(sender: UITextField) {
        FormCustomization.aplicarMascaraMoeda(&sender.text!)
    }
    
    @IBAction func maskTextData(sender: UITextField) {
        FormCustomization.aplicarMascaraData(&sender.text!, data: Data.formatDateToString(self.pickerView.date))
    }
    
    // MARK: - Delegate methods
    
    func updateTextField(sende:UIDatePicker){
        
        txtData.text = Data.formatDateToString(sende.date)
    }
    
    func contasViewControllerResponse(conta: Conta) {
        self.conta = conta
        txtConta.text = conta.nome
    }
    
    func categoriaViewControllerResponse(categoria:Categoria){
        self.categoria = categoria
        txtCategoria.text = categoria.nome
    }
    
    func localViewControllerResponse(local:Local){
        self.local = local
        txtEndereco.text = local.nome
    }
    
    // MARK: - Private functions
    
    private func dissmissViewController(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    private func validarCampos(){
        if Validador.vazio(txtNome.text!){
            erros.appendContentsOf("\nPreencha o campo nome!")
        }
        
        if Validador.vazio(txtValor.text!.currencyToFloat()){
            erros.appendContentsOf("\nAdicione um valor!")
        }
        
        if Validador.vazio(txtEndereco.text!){
            erros.appendContentsOf("\nSelecione o Local!")
        }
        
        if Validador.vazio(txtConta.text!){
            erros.appendContentsOf("\nSelecione a Conta!")
        }
        
        if Validador.vazio(txtCategoria.text!){
            erros.appendContentsOf("\nSelecione a Categoria!")
        }
    }
    
    private func addConta(){
        
        validarCampos()
        
        if(erros.isEmpty){
            
            func dados(){
                despesa = Despesa.getDespesa()
                despesa?.nome = txtNome.text
                despesa?.descricao = txtDescricao.text
                despesa?.valor = txtValor.text!.currencyToFloat()
                despesa?.conta = conta
                despesa?.categoria = categoria
                despesa?.local = local
                despesa?.data = Data.removerTime(txtData.text!)
                indexChanged(sgFglTipo)
                
                conta?.saldo = Float((conta?.saldo)!) - Float((despesa?.valor)!)
                
                salvarConta()
            }
            
            let novoSaldo = Float((conta?.saldo)!) - (txtValor.text?.currencyToFloat())!
            
            if (Float((conta?.saldo)!) <= 0){
                
                let alert = Notification.solicitarConfirmacaoDespesa("Cuidado!", mensagem: "A conta \(conta!.nome!) já está negativa, tem certeza?", completion: {
                    (action:UIAlertAction) in
                    dados()
                })
                presentViewController(alert, animated: true, completion: nil)
            }
            if (novoSaldo < 0){
                
                let alert = Notification.solicitarConfirmacaoDespesa("Cuidado!", mensagem: "A conta \(conta!.nome!) ficará negativa ao salvar, tem certeza?", completion: {
                    (action:UIAlertAction) in
                    dados()
                })
                presentViewController(alert, animated: true, completion: nil)
            } else {
                
                dados()
            }
            
        } else {
            
            let alert = Notification.mostrarErro("Campos vazio", mensagem: "\(erros)")
            presentViewController(alert, animated: true, completion: nil)
            self.erros = ""
        }
    }
    
    private func updateConta(){
        
        validarCampos()
        
        if (erros.isEmpty) {
            
            despesa?.nome = txtNome.text
            despesa?.descricao = txtDescricao.text
            indexChanged(sgFglTipo)
            
            if let categoria = categoria {
                despesa?.categoria = categoria
            }
            
            if let local = local {
                despesa?.local = local
            }
            
            salvarConta()
        } else {
            
            let alert = Notification.mostrarErro("Campos vazio", mensagem: "\(erros)")
            presentViewController(alert, animated: true, completion: nil)
            self.erros = ""
        }
    }
    
    private func salvarConta(){
        
        do{
            try despesaDAO.salvar(despesa!)
        }catch{
            let alert = Notification.mostrarErro("Desculpe", mensagem: "Não foi possível salvar")
            presentViewController(alert, animated: true, completion: nil)
        }
        
        dissmissViewController()
        
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
