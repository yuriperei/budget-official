//
//  LocalViewController.swift
//  Budget
//
//  Created by Yuri Pereira on 4/1/16.
//  Copyright © 2016 Budget Company. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class LocalViewController: UITableViewController, CLLocationManagerDelegate {

    let localDAO:LocalDAO = LocalDAO()
    let locationManager = CLLocationManager()
    
    var local: Local?
    var erros: String = ""
    var cidade:String = ""
    var estado:String = ""
    var rua:String = ""
    
    @IBOutlet weak var navegacao: UINavigationItem!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtCidade: UITextField!
    @IBOutlet weak var txtEstado: UITextField!
    @IBOutlet weak var txtRua: UITextField!
    @IBOutlet weak var switchEnderecoAtual: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let local = local {
            txtNome.text = local.nome!
            txtCidade.text = local.cidade!
            txtEstado.text = local.estado!
            txtRua.text = local.rua
            
            // Armazenar endereço para recuperar, em caso de necessidade.
            self.cidade = self.txtCidade.text!
            self.estado = self.txtEstado.text!
            self.rua = self.txtRua.text!
            
        }
        
        FormCustomization.alignLabelsWidths(labels)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.local == nil{
            return 2
        }else{
            return 3
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch(section) {
        case 0: return 1    // section 0 has 1 rows
        case 1: return 4    // section 1 has 4 row
        case 2: return 1    // section 2 has 1 row
        default: fatalError("Unknown number of sections")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "mapa"{
            let contaController : MapaViewController = segue.destinationViewController as! MapaViewController
            if self.switchEnderecoAtual.on{
                contaController.endereco = self.txtRua.text! + " - " + self.txtCidade.text! + " - " + self.txtEstado.text!
            }else if (self.cidade != self.local?.cidade! || self.estado != self.local?.estado! || self.rua != self.local?.rua){
                contaController.endereco = self.txtRua.text! + " - " + self.txtCidade.text! + " - " + self.txtEstado.text!
            }else{
                contaController.local = self.local!
            }
        }
    }
    
    // MARK: - IBAction functions
    
    @IBAction func stateChanged(switchState: UISwitch) {
        if switchEnderecoAtual.on{
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }else{
            self.txtCidade.text = self.cidade
            self.txtEstado.text = self.estado
            self.txtRua.text = self.rua
        }
    }
    
    @IBAction func btnCancel(sender: AnyObject) {
        dissmissViewController()
    }
    
    @IBAction func btnSave(sender: AnyObject) {
        
        if local != nil {
            updateConta()
        }else{
            addConta()
            
        }
    }
    
    @IBAction func endCidade(sender: UITextField) {
        self.cidade = self.txtCidade.text!
    }
    
    @IBAction func endEstado(sender: UITextField) {
        self.estado = self.txtEstado.text!
    }
    
    @IBAction func endRua(sender: UITextField) {
        self.rua = self.txtRua.text!
    }
    
    // MARK: - Delegate methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                let alerta = Notification.mostrarErro("Erro", mensagem: "Não foi possível obter a localização")
                self.presentViewController(alerta, animated: true, completion: nil)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                self.displayLocationInfo(pm)
                pm.location?.coordinate
            } else {
                let alerta = Notification.mostrarErro("Erro", mensagem: "Não foi possível obter a localização")
                self.presentViewController(alerta, animated: true, completion: nil)
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //Para atualização de local para economia de bateria
            locationManager.stopUpdatingLocation()
            
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let name = (containsPlacemark.name != nil) ? containsPlacemark.name : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            
            self.txtCidade.text = locality
            self.txtEstado.text = administrativeArea
            self.txtRua.text = name
        }
        
    }
    
    // MARK: - Private functions
    
    private func dissmissViewController(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    private func validarCampos(){
        if Validador.vazio(txtNome.text!){
            erros.appendContentsOf("\nPreencha o campo Nome!")
        }
        
        if Validador.vazio(txtCidade.text!){
            erros.appendContentsOf("\nPreencha o campo Cidade!")
        }
        
        if Validador.vazio(txtEstado.text!){
            erros.appendContentsOf("\nPreencha o campo Estado!")
        }
        
        if Validador.vazio(txtRua.text!){
            erros.appendContentsOf("\nPreencha o campo Rua e Número!")
        }
    }
    
    private func addConta(){
        
        validarCampos()
        
        if(erros.isEmpty){
            local = Local.getLocal()
            local?.nome = txtNome.text
            local?.cidade = txtCidade.text
            local?.estado = txtEstado.text
            local?.rua = txtRua.text
            
            salvarConta()
            
        }else{
            let alert = Notification.mostrarErro("Campos vazio", mensagem: "\(erros)")
            presentViewController(alert, animated: true, completion: nil)
            self.erros = ""
        }
    }
    
    private func updateConta(){
        
        validarCampos()
        
        if(erros.isEmpty){
            local?.nome = txtNome.text
            local?.cidade = txtCidade.text
            local?.estado = txtEstado.text
            local?.rua = txtRua.text
            
            salvarConta()
            
        }else{
            let alert = Notification.mostrarErro("Campos vazio", mensagem: "\(erros)")
            presentViewController(alert, animated: true, completion: nil)
            self.erros = ""
        }
    }
    
    private func salvarConta(){
        
        do{
            try localDAO.salvar(local!)
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

/*
Comentários temporários

private func calculateLabelWidth(label: UILabel) -> CGFloat {
let labelSize = label.sizeThatFits(CGSize(width: CGFloat.max, height: label.frame.height))

return labelSize.width
}

private func calculateMaxLabelWidth(labels: [UILabel]) -> CGFloat {
return labels.map(calculateLabelWidth).reduce(0, combine: max)
}

private func updateWidthsForLabels(labels: [UILabel]) {
let maxLabelWidth = calculateMaxLabelWidth(labels)
for label in labels {
let constraint = NSLayoutConstraint(item: label,
attribute: .Width,
relatedBy: .Equal,
toItem: nil,
attribute: .NotAnAttribute,
multiplier: 1,
constant: maxLabelWidth)
label.addConstraint(constraint)
}
}
//switchEnderecoAtual.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
//            let throughfare = (containsPlacemark.thoroughfare != nil) ? containsPlacemark.thoroughfare : ""
//            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
*/