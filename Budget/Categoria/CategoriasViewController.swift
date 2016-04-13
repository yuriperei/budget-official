//
//  CategoriasViewController.swift
//  Budget
//
//  Created by md10 on 3/23/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

class CategoriasViewController: UITableViewController {

    let categoriaDAO:CategoriaDAO = CategoriaDAO()
    
    var categoria: Categoria?
    var erros: String = ""
    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var txtNome: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let categoria = categoria{
            txtNome.text = categoria.nome!
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    // MARK: - IBActions functions
    
    @IBAction func btnCancel(sender: AnyObject) {
        
        dissmissViewController()
    }
    
    
    @IBAction func btnSave(sender: AnyObject) {
        addConta()
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Private functions
    
    private func dissmissViewController(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    private func validarCampos(){
        if Validador.vazio(txtNome.text!){
            erros.appendContentsOf("\nPreencha o campo nome!")
        }
    }
    
    private func addConta(){
        
        validarCampos()
        
        if (erros.isEmpty){
            categoria = Categoria.getCategoria()
            
            categoria?.nome = txtNome.text

            salvarConta()
            
        }else{
            let alert = Notification.mostrarErro("Campo vazio", mensagem: "\(erros)")
            presentViewController(alert, animated: true, completion: nil)
            self.erros = ""
        }
        
    }
    
    private func salvarConta(){
        
        do{
            try categoriaDAO.salvar(categoria!)
        }catch{
            let alert = Notification.mostrarErro("Desculpe", mensagem: "Não foi possível salvar")
            presentViewController(alert, animated: true, completion: nil)
        }
        
    }

}
