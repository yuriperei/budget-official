//
//  CalculadoraController.swift
//  Budget
//
//  Created by md10 on 3/3/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit

class CalculadoraController: UIViewController {

    @IBOutlet weak var lblResultado: UILabel!
    @IBOutlet weak var lblOperador: UILabel!
    @IBOutlet weak var lblVisor: UILabel!
    @IBOutlet weak var btnSidebar: UIBarButtonItem!
    @IBOutlet weak var btnClear: UIButton!
    
    var numberInText:String = ""
    var operatorInText:String = ""
    var resultado:Bool = false
    
    var calculadora:Calculadora?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculadora = Calculadora()
        // Do any additional setup after loading the view.
        SidebarMenu.configMenu(self, sideBarMenu: btnSidebar)
        let longPress = UILongPressGestureRecognizer(target: self, action: "limparTudo:")
        self.btnClear.addGestureRecognizer(longPress)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func getLastChar(string: String) -> String{
//        
////        let string = lblVisor.text
//        
//        return string.substringFromIndex(string.endIndex.predecessor())
//        
////        let index2 = string!.rangeOfString(lblOperador.text!, options: .BackwardsSearch)?.startIndex
////        if let index = index2?.advancedBy(1){
////            
////            return (string!.substringWithRange(Range<String.Index>(start: index, end: lblVisor.text!.endIndex)))
////        }
////        return lblVisor.text!
//    }
    
    
    
    @IBAction func inserirNumero(sender: UIButton) {
//        if((calculadora?.numeroAtual == 0)){
//            lblVisor.text = sender.currentTitle
//        } else {
//            lblVisor.text?.appendContentsOf(sender.currentTitle!)
//        }
        if(numberInText == ""){
            numberInText = sender.currentTitle!
        } else {
            numberInText.appendContentsOf(sender.currentTitle!)
        }
        
        calculadora?.numeroAtual = numberInText.doubleValue
        
        if ((lblVisor.text == "0") || (resultado)) {
            lblVisor.text = sender.currentTitle!
        } else {
            lblVisor.text?.appendContentsOf(sender.currentTitle!)
        }
        resultado = false
    }
    
    @IBAction func inserirDecimal(sender: UIButton) {
        if (!(numberInText.containsString("."))) {
            lblVisor.text?.appendContentsOf(".")
            numberInText.appendContentsOf(".")
        }
        resultado = false
    }

    @IBAction func inserirOperacao(sender: UIButton) {
        
        resultado = false
        if let operatorInText = sender.currentTitle {
            if(operatorInText == "-" && lblVisor.text == "0"){
                lblVisor.text = operatorInText
                numberInText = operatorInText
            } else {
            //let lastChar = getLastChar(lblVisor.text!)
            switch(lblVisor.text!.lastChar){
//                case "-":
//                    
//                    break;
                case "+","-","/","x":
                    break;
            default:
                lblVisor.text?.appendContentsOf(operatorInText)
                break;
            }
                calculadora?.numeroAtual = numberInText.doubleValue
                if(calculadora?.numeroFinal == 0){
                    calculadora?.numeroFinal = calculadora!.numeroAtual
                    
                    //                    lblResultado.text = calculadora!.numeroFinal.stringValue
                } else if(calculadora?.numeroAtual != 0){
                    
                    lblResultado.text = calculadora!.calcularOperacao().stringValue
                }
                
                calculadora?.opcao = sender.tag
                calculadora?.numeroAtual = 0
                numberInText = ""
            }
//            if(sender.currentTitle == "-" && calculadora?.numeroAtual == 0){
//                lblVisor.text = sender.currentTitle!
//            }else{
            
//            lblVisor.text = "0"
//                lblVisor.text?.appendContentsOf(sender.currentTitle!)
            
//                lblOperador.text = sender.currentTitle
//            }
        }
    }
    
    @IBAction func realizarOperacao(sender: UIButton) {
        if (calculadora?.numeroAtual != 0) {
            lblVisor.text = calculadora!.calcularOperacao().stringValue
            lblResultado.text = ""
            numberInText = ""
            calculadora?.numeroAtual = 0
            resultado = true
        }
//      calculadora?.numeroFinal = calculadora!.numeroAtual
//      calculadora?.numeroFinal = lblResultado.text!.floatValue
//      calculadora?.numeroFinal = 0
//      lblResultado.text = ""
//      lblOperador.text = ""
    }
    
    @IBAction func limparVisor(sender: UIButton) {
//        calculadora?.numeroAtual = 0
//        calculadora?.numeroFinal = 0
//        lblResultado.text = ""
//        lblVisor.text = "0"
//        numberInText = ""
        if let lastChar = lblVisor.text?.lastChar {
            switch(lastChar){
            case "-","+","/","x":
                calculadora?.opcao = 0
                break;
            case ".":
                break;
            case "":
                break;
            default:
                if(!resultado){
                    numberInText.removeLastChar()
                    calculadora?.numeroAtual = (calculadora?.numeroAtual)!.removeLastNumber()
                } else {
                    calculadora?.numeroFinal = (calculadora?.numeroFinal)!.removeLastNumber()
                }
                break;
            }
        }
        lblVisor.text?.removeLastChar()
        if(lblVisor.text == ""){
//            lblVisor.text = "0"
//            lblResultado.text = ""
            self.limparTudo()
        }
        
    }
    
    func limparTudo(sender: UILongPressGestureRecognizer? = nil){
        calculadora?.limparCalculadora()
        lblVisor.text = "0"
        lblResultado.text = ""
        numberInText = ""
        operatorInText = ""
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
