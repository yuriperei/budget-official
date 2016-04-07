//
//  CalculadoraJurosController.swift
//  Budget
//
//  Created by Calebe Santos on 3/7/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit

class PorcentagemController: UITableViewController, UITextFieldDelegate {

    var calculadora: Calculadora?
    
    @IBOutlet weak var lblSegundoValor: UILabel!
    @IBOutlet weak var lblPrimeiroValor: UILabel!
    
    @IBOutlet weak var txtPrimeiroValor: UITextField!
    @IBOutlet weak var txtSegundoValor: UITextField!
    @IBOutlet weak var lblResultado: UILabel!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var sgmTipo: UISegmentedControl!
    @IBOutlet weak var btnSideBar: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SidebarMenu.configMenu(self, sideBarMenu: btnSideBar)
        txtPrimeiroValor.delegate = self
        calculadora = Porcentagem()
        FormCustomization.updateWidthsForLabels(labels)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func maskTextField(sender: UITextField) {
        FormCustomization.aplicarMascara(&sender.text!)
    }
    
    @IBAction func calcularValorPorcentagem(sender: UIButton) {
        //Porcentagem do valor
        if (sgmTipo.selectedSegmentIndex == 0) {
            calculadora?.numeroAtual = txtSegundoValor.text!.doubleConverterMoeda()
            if let calculadora = calculadora as? Porcentagem {
                calculadora.porcentagem = txtPrimeiroValor.text!.doubleConverter
                lblResultado.text = calculadora.calcularPorcentagemDoValor().convertToMoedaBr()
            }
        } else {
            calcularPercentualValor(sender)
        }
    }
    
    @IBAction func calcularPercentualValor(sender: UIButton) {
        //Valor porcentagem
        calculadora?.numeroAtual = txtPrimeiroValor.text!.doubleConverterMoeda()
        calculadora?.numeroFinal = txtSegundoValor.text!.doubleConverterMoeda()
        
        if let calculadora = calculadora as? Porcentagem {
            lblResultado.text = String(format: "%.4g", calculadora.calcularValorPorcentagem()) + "%"
        }
    }
    
    @IBAction func changeLabelPorcentagem(sender: UISegmentedControl) {
        if (sgmTipo.selectedSegmentIndex == 0) {
            lblPrimeiroValor.text = "Porcentagem:"
            txtPrimeiroValor.text = ""
            txtPrimeiroValor.removeTarget(self, action: "maskTextField:", forControlEvents: .EditingChanged)
        } else {
            lblPrimeiroValor.text = "Valor parcial:"
            txtPrimeiroValor.text = "R$0,00"
            txtPrimeiroValor.addTarget(self, action: "maskTextField:", forControlEvents: .EditingChanged)
        }
    }
    
    @IBAction func changePlaceholderVariacao(sender: UISegmentedControl) {
        if (sgmTipo.selectedSegmentIndex == 0) {
            txtSegundoValor.placeholder = "Valor aumentado"
        } else {
            txtSegundoValor.placeholder = "Valor reduzido"
        }
    }
    
    @IBAction func calcularVariacao(sender: UIButton) {
        //Aumento percentual
        calculadora?.numeroAtual = txtSegundoValor.text!.doubleConverterMoeda()
        calculadora?.numeroFinal = txtPrimeiroValor.text!.doubleConverterMoeda()
        
        if let calculadora = calculadora as? Porcentagem {
            if (calculadora.numeroFinal<=calculadora.numeroAtual) {
                lblResultado.text = String(format: "%.4g", calculadora.calcularAumentoPercentual()) + "%"
            } else {
                lblResultado.text = String(format: "%.4g", calculadora.calcularDiminuicaoPercentual()) + "%"
            }
        }
//        
//        //Diminuição percentual
//        calculadora?.numeroAtual = txtPrimeiroValor.text!.floatValue
//        calculadora?.numeroFinal = txtSegundoValor.text!.floatValue
//        if let calculadora = calculadora as? Porcentagem {
//            print(calculadora.calcularDiminuicaoPercentual())
//        }
    }
    
    @IBAction func calcularValorInicial(sender: UIButton) {
        //Valor inicial com aumento
        calculadora?.numeroFinal = txtPrimeiroValor.text!.doubleConverterMoeda()
        
        if let calculadora = calculadora as? Porcentagem {
            calculadora.porcentagem = txtSegundoValor.text!.doubleValue
            
            if (sgmTipo.selectedSegmentIndex == 0) {
                lblResultado.text = calculadora.calcularValorInicialAumentado().convertToMoedaBr()
            } else {
                lblResultado.text = calculadora.calcularValorInicialDiminuido().convertToMoedaBr()
            }
        }
    }
    
    @IBAction func calcularJurosDescontos(sender: UIButton) {
        //Juros
        calculadora?.numeroAtual = txtPrimeiroValor.text!.doubleConverterMoeda()
        
        if let calculadora = calculadora as? Porcentagem {
            calculadora.porcentagem = txtSegundoValor.text!.doubleValue
            
            if (sgmTipo.selectedSegmentIndex == 0) {
                lblResultado.text = calculadora.calcularValorComJuros().convertToMoedaBr()
            } else {
                lblResultado.text = calculadora.calcularValorComDesconto().convertToMoedaBr()
            }
        }
        
        //Desconto
//        calculadora?.numeroAtual = 1000
//        
//        if let calculadora = calculadora as? Porcentagem {
//            calculadora.porcentagem = 15
//            print(calculadora.calcularValorComDesconto())
//        }
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
