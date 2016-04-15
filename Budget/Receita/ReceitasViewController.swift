//
//  ReceitasViewController.swift
//  Budget
//
//  Created by Yuri Pereira on 3/23/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

class ReceitasViewController: UITableViewController, ContasViewControllerDelegate, CategoriaViewControllerDelegate, LocalViewControllerDelegate, UIGestureRecognizerDelegate  {

    let receitaDAO:ReceitaDAO = ReceitaDAO()
    
    var erros: String = ""
    var conta: Conta?
    var categoria: Categoria?
    var receita: Receita?
    var local: Local?
    var pickerView: UIDatePicker!
    var tap: UITapGestureRecognizer!
    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtDescricao: UITextField!
    @IBOutlet weak var txtValor: UITextField!
    @IBOutlet weak var txtEndereco: UITextField!
    @IBOutlet weak var txtConta: UITextField!
    @IBOutlet weak var txtCategoria: UITextField!
    @IBOutlet weak var txtData: UITextField!
    
    @IBOutlet var textViews:[UITextField]!
    
    // MARK: - Private Functions
    
    private func addDismissInputView() {
        tap = UITapGestureRecognizer(target: self, action: Selector("dismiss:"))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    // MARK: - Selector Functions
    
    func dismiss(sender: UITapGestureRecognizer? = nil) {
        FormCustomization.dismissInputView(textViews)
        self.view.removeGestureRecognizer(tap)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView = UIDatePicker()
        pickerView.datePickerMode = UIDatePickerMode.Date
        pickerView.addTarget(self, action: "updateTextField:", forControlEvents: .ValueChanged)
        
        if let receita = receita {
            
            txtNome.text = receita.nome!
            txtValor.text = receita.valor!.convertToCurrency("pt_BR")
            txtDescricao.text = receita.descricao!
            txtData.text = Data.formatDateToString(receita.data!)
            
            txtValor.enabled = false
            txtData.enabled = false
            txtConta.enabled = false
            
            conta = receita.conta
            categoria = receita.categoria
            local = receita.local
            
        } else {
            
            txtData.text = Data.formatDateToString(pickerView.date)
        }
        
        txtConta.text = self.conta?.nome!
        txtCategoria.text = self.categoria?.nome!
        txtEndereco.text = self.local?.nome!
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
        
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch(section) {
        case 0: return 5    // section 0 has 2 rows
        case 1: return 1    // section 1 has 1 row
        case 2: return 1    // section 2 has 1 row
        default: fatalError("Unknown number of sections")
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        FormCustomization.dismissInputView([txtNome, txtDescricao, txtValor, txtData])
        
        if segue.identifier == "alterarConta"{
            let contasController : ContasTableViewController = segue.destinationViewController as! ContasTableViewController
            contasController.delegate = self
            contasController.tela = true
        }else if segue.identifier == "alterarCategoriaReceita"{
            let categoriasController : CategoriaTableViewController = segue.destinationViewController as! CategoriaTableViewController
            categoriasController.delegate = self
            categoriasController.tela = true
            
        }else if segue.identifier == "alterarLocalReceita"{
            let locaisController : LocalTableViewController = segue.destinationViewController as! LocalTableViewController
            locaisController.delegate = self
            locaisController.tela = true
            
        }
        
    }
    
    // Bloqueia determinados campos caso esteja sendo feita alguma alteração
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if receita == nil{
            return true
        }
        
        if identifier == "alterarCategoriaReceita"{
            return true
        }
        
        if identifier == "alterarLocalReceita"{
            return true
        }
        
        return false
    }
    
    // MARK: - Delegate methods
    
    func updateTextField(sender:UIDatePicker){
        txtData.text = Data.formatDateToString(sender.date)
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
    
    // MARK: - IBActions functions
    
    @IBAction func addInputView(sender:AnyObject){
        self.view.addGestureRecognizer(tap)
    }
    
    @IBAction func removeInputViewLocal(sender: AnyObject) {
        performSegueWithIdentifier("alterarLocalReceita", sender: sender)
    }
    
    @IBAction func removeInputViewConta(sender: AnyObject) {
        performSegueWithIdentifier("alterarConta", sender: sender)
    }
    
    @IBAction func removeInputViewCategoria(sender: AnyObject) {
        performSegueWithIdentifier("alterarCategoriaReceita", sender: sender)
    }
    
    @IBAction func btnCancel(sender: AnyObject) {
        dissmissViewController()
    }
    
    
    @IBAction func btnSave(sender: AnyObject) {
        
        if receita != nil {
            updateConta()
        }else{
            addConta()
        }
    }
    
    @IBAction func maskTextField(sender: UITextField) {
        FormCustomization.aplicarMascaraMoeda(&sender.text!)
    }
    
    @IBAction func maskTextData(sender: UITextField) {
        FormCustomization.aplicarMascaraData(&sender.text!, data: Data.formatDateToString(self.pickerView.date))
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
    
    private func addConta() {
        
        func dados() {
            
            receita = Receita.getReceita()
            receita?.nome = txtNome.text
            receita?.descricao = txtDescricao.text
            receita?.valor = txtValor.text!.currencyToFloat()
            receita?.conta = conta
            receita?.categoria = categoria
            receita?.local = local
            receita?.data = Data.removerTime(txtData.text!)
            
            conta?.saldo = Float((receita?.valor)!) + Float((conta?.saldo)!)
            
            salvarConta()
        }
        
        validarCampos()
        
        if (erros.isEmpty) {
            
            let novoSaldo = Float((conta?.saldo)!) + (txtValor.text?.currencyToFloat())!
            
            if (Float((conta?.saldo)!) <= 0 && novoSaldo > 0){
                
                let alert = Notification.avisoReceita("Parabéns!", mensagem: "A conta \(conta!.nome!) ficará com saldo positivo", completion: {
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
        
        if(erros.isEmpty){
            receita?.nome = txtNome.text
            receita?.descricao = txtDescricao.text
            
            if let categoria = categoria{
                receita?.categoria = categoria
            }
            
            if let local = local{
                receita?.local = local
            }
            
            salvarConta()
            
        }else{
            
            let alert = Notification.mostrarErro("Campos vazio", mensagem: "\(erros)")
            presentViewController(alert, animated: true, completion: nil)
            self.erros = ""
        }
        

    }
    
    private func salvarConta(){

        do {
            
            try receitaDAO.salvar(receita!)
        } catch {
            
            let alert = Notification.mostrarErro("Desculpe", mensagem: "Não foi possível salvar")
            presentViewController(alert, animated: true, completion: nil)
        }
        
        dissmissViewController()
    }

}
