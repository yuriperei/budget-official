//
//  ContasViewController.swift
//  Budget
//
//  Created by Yuri Pereira on 3/23/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

class ContasViewController: UITableViewController, TipoContasViewControllerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    let contaDAO:ContaDAO = ContaDAO()
    
    var currentString = ""
    var erros: String = ""
    var conta: Conta?
    var tipoConta: TipoConta?
    var tap: UITapGestureRecognizer!
    
    @IBOutlet var textViews:[UITextField]!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtSaldo: UITextField!
    @IBOutlet weak var txtTipo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtSaldo.delegate = self
        
        if let conta = conta {
            txtNome.text = conta.nome!
            
            if let saldo = conta.saldo?.floatValue{
                txtSaldo.text = saldo.convertToCurrency("pt_BR")
            }
            
            tipoConta = conta.tipoconta
            
            txtSaldo.enabled = false
        }
        
        txtTipo.text = tipoConta?.nome
        
        FormCustomization.alignLabelsWidths(labels)
        addDismissInputView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch(section) {
        case 0: return 2    // section 0 has 2 rows
        case 1: return 1    // section 1 has 1 row
        default: fatalError("Unknown number of sections")
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        FormCustomization.dismissInputView([txtNome, txtSaldo])
        
        if segue.identifier == "alterarTipoConta" {
            
            let tipoContasController : TipoContasTableViewController = segue.destinationViewController as! TipoContasTableViewController
            
            tipoContasController.delegate = self
            tipoContasController.tela = true
        }
        
    }
    
    // MARK: - Delegate Methods
    
    func tipoContasViewControllerResponse(tipoConta: TipoConta) {
        self.tipoConta = tipoConta
        txtTipo.text = tipoConta.nome
    }
    
    // MARK: - IBAction functions
    
    @IBAction func addInputView(sender:AnyObject){
        self.view.addGestureRecognizer(tap)
    }
    
    @IBAction func removeInputView(sender: AnyObject) {
        performSegueWithIdentifier("alterarTipoConta", sender: sender)
    }
    
    @IBAction func maskTextField(sender: UITextField) {
        FormCustomization.aplicarMascaraMoeda(&sender.text!)
    }
    
    
    @IBAction func btnCancel(sender: AnyObject) {
        dissmissViewController()
    }
    
    
    @IBAction func btnSave(sender: AnyObject) {
        
        if conta != nil {
            updateConta()
        }else{
            addConta()
        }
        
        
    }
    
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
    
    // MARK: Private functions
    
    private func dissmissViewController(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    private func validarCampos(){
        if Validador.vazio(txtNome.text!){
            erros.appendContentsOf("\nPreencha o campo nome!")
        }
        
        if Validador.vazio(txtSaldo.text!){
            erros.appendContentsOf("\nPreencha o campo Saldo!")
        }
        
        if Validador.vazio(txtTipo.text!){
            erros.appendContentsOf("\nSelecione a Conta!")
        }
    }
    
    private func addConta(){
        
        validarCampos()
        
        if (erros.isEmpty == true){
            
            conta = Conta.getConta()
            conta?.nome = txtNome.text
            conta?.saldo = txtSaldo.text?.currencyToFloat()
            conta?.tipoconta = tipoConta
            
            salvarConta()
        }else{
            let alert = Notification.mostrarErro("Campos vazio", mensagem: "\(erros)")
            presentViewController(alert, animated: true, completion: nil)
            self.erros = ""
        }
    }
    
    private func updateConta(){
        
        conta?.nome = txtNome.text
        conta?.saldo = txtSaldo.text!.currencyToFloat()
        
        if let tipoConta = tipoConta {
            conta?.tipoconta? = tipoConta
        }
        
        salvarConta()
    }
    
    private func salvarConta(){
        
        do{
            try contaDAO.salvar(conta!)
        }catch{
            let alert = Notification.mostrarErro("Desculpe", mensagem: "Não foi possível salvar")
            presentViewController(alert, animated: true, completion: nil)
        }
        
        dissmissViewController()
        
    }

}