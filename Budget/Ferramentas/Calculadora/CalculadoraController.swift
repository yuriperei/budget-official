//
//  CalculadoraController.swift
//  Budget
//
//  Created by md10 on 3/3/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit

func += (inout leftSide:String, rightSide:String) {
    leftSide.appendContentsOf(rightSide)
}

class CalculadoraController: UIViewController {

    var numberInText:String = ""
    var flgResultado:Bool = false //Flag para verificar se o número exibido é um resultado
    var calculadora:Calculadora!
    
    @IBOutlet weak var lblResultado: UILabel!
    @IBOutlet weak var lblOperador: UILabel!
    @IBOutlet weak var lblVisor: UILabel!
    @IBOutlet weak var btnSidebar: UIBarButtonItem!
    @IBOutlet weak var btnClear: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculadora = Calculadora()
        
        SidebarMenu.configMenu(self, sideBarMenu: btnSidebar)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: "limparTudo:")
        self.btnClear.addGestureRecognizer(longPress)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions functions
    
    @IBAction func inserirNumero(btnNumero: UIButton) {
        
        if let numero = btnNumero.currentTitle, var visorText = lblVisor.text {
        
            if (numberInText == "") {
                
                numberInText = numero
            } else {
                
                numberInText += numero
            }
            
            if ((visorText.isEmpty) || (flgResultado)) {
                visorText = numero
            } else {
                visorText += numero
            }
            
            lblVisor.text = visorText
        }
        
        calculadora.numeroAtual = numberInText.doubleValue
        flgResultado = false
    }
    
    @IBAction func inserirDecimal(sender: UIButton) {
        
        if (!numberInText.containsString(".")) {
            
            lblVisor.text! += "."
            numberInText += "."
        }
        
        flgResultado = false
    }

    @IBAction func inserirOperacao(btnOperador: UIButton) {
        
        if let operatorInText = btnOperador.currentTitle, var visorText = lblVisor.text {
            
            // Se a pessoa clicou no "-" e é um novo número
            // considerar que o próximo número a ser digitado será negativo
            if (operatorInText == "-" && visorText.isEmpty) {
                
                visorText += operatorInText
                numberInText = operatorInText
            } else {
                if (flgResultado) {
                    numberInText = visorText
                }
                
                calculadora.numeroAtual = numberInText.doubleValue
                numberInText = "" //Limpar a variável pois ela pode sofrer alteração para aceitar números negativos
                
                switch(lblVisor.text!.lastChar){
                case ".":
                    visorText.removeLastChar()
                    visorText += operatorInText
                    break;
                case "+","-":
                    break;
                case "/","X":
                    if (operatorInText == "-") {
                        numberInText = operatorInText
                        visorText += operatorInText
                    }
                    break;
                default:
                    visorText += operatorInText
                    
                    break;
                }
                
                if (calculadora.numeroFinal == 0) {
                    
                    calculadora.numeroFinal = calculadora!.numeroAtual
                } else if(calculadora.numeroAtual != 0){
                    
                    lblResultado.text = calculadora.calcularOperacao().stringValue
                }
                
                // As opções de operação da calculadora estão em números inteiro
                // Opções: 1(+) 2(-) 3(/) 4(*)
                // Verificação necessária pois após escolher / ou * não pode receber a opção -
                if (calculadora.opcao == 0) {
                    calculadora.opcao = btnOperador.tag
                }
                
                calculadora.numeroAtual = 0
            }
            
            lblVisor.text = visorText
        }
        
        flgResultado = false
    }
    
    @IBAction func realizarOperacao(sender: UIButton) {
        
        if (calculadora.numeroAtual != 0 && calculadora.opcao != 0) {
            
            lblVisor.text = calculadora!.calcularOperacao().stringValue
            lblResultado.text = ""
            numberInText = ""
            calculadora.numeroAtual = 0
            calculadora.numeroFinal = 0
            flgResultado = true
        }
    }
    
    @IBAction func limparVisor(sender: UIButton) {
        
        if let lastChar = lblVisor.text?.lastChar {
            
            switch(lastChar){
            case "-","+","/","x":
                calculadora.opcao = 0
                break;
            case ".":
                numberInText.removeLastChar()
                break;
            default:
                if(!flgResultado){
                    numberInText.removeLastChar()
                    calculadora.numeroAtual = calculadora.numeroAtual.removeLastNumber()
                } else {
                    calculadora.numeroFinal = calculadora.numeroFinal.removeLastNumber()
                }
                break;
            }
        }
        
        lblVisor.text?.removeLastChar()
        if(lblVisor.text == ""){
            self.limparTudo()
        }
        
    }
    
    // MARK: - Private functions
    
    func limparTudo(sender: UILongPressGestureRecognizer? = nil){
        calculadora.limparCalculadora()
        lblVisor.text = ""
        lblResultado.text = ""
        numberInText = ""
        //operatorInText = ""
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
/*
Comentários temporários
//            if(sender.currentTitle == "-" && calculadora.numeroAtual == 0){
//                lblVisor.text = sender.currentTitle!
//            }else{

//            lblVisor.text = "0"
//                lblVisor.text?.appendContentsOf(sender.currentTitle!)

//                lblOperador.text = sender.currentTitle
//            }

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
//      calculadora.numeroFinal = calculadora!.numeroAtual
//      calculadora.numeroFinal = lblResultado.text!.floatValue
//      calculadora.numeroFinal = 0
//      lblResultado.text = ""
//      lblOperador.text = ""

//        calculadora.numeroAtual = 0
//        calculadora.numeroFinal = 0
//        lblResultado.text = ""
//        lblVisor.text = "0"
//        numberInText = ""

//        if((calculadora.numeroAtual == 0)){
//            lblVisor.text = sender.currentTitle
//        } else {
//            lblVisor.text?.appendContentsOf(sender.currentTitle!)
//        }

    //var operatorInText:String = ""
*/