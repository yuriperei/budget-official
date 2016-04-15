//
//  CalculadoraJurosController.swift
//  Budget
//
//  Created by Calebe Santos on 3/7/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit

class ManualFinanceiroController: UIViewController {
    
    @IBOutlet weak var lblExplicacao: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 650)

        lblExplicacao.text = "Para avaliar qual é a melhor opção, faremos uma comparação da taxa de juros embutida na compra a prazo com a taxa de juros dos seus investimentos.\n\nEscolha uma das opções abaixo, para avaliar qual será a melhor opção:\n\nTenho investimento?\nSe a taxa de juros da loja para venda à prazo for menor que a taxa de rentabilidade do seu investimento  então é melhor manter o dinheiro investido e realizar a compra à prazo;\n\nTenho cartão de crédito?\nSe o preço à vista, em dinheiro, é igual ao preço no cartão de crédito, prefira comprar nele. Se for possível, peça para parcelar no máximo de vezes sem juros, desde que o seu limite de crédito permita.\n\nQuando pagar no Cartão de Débito ou em dinheiro?\nSe o preço à vista for igual ao preço no cartão de débito e não houver possibilidade de parcelamento sem juros, então use o débito."
    }
    
    @IBAction func dissmissView(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}
