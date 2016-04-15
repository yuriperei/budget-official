//
//  Protocols.swift
//  Budget
//
//  Created by Calebe Santos on 4/12/16.
//  Copyright © 2016 Budget Company. All rights reserved.
//

import Foundation

protocol LocalViewControllerDelegate: class {
    func localViewControllerResponse(local:Local)
}

protocol CategoriaViewControllerDelegate: class {
    func categoriaViewControllerResponse(categoria:Categoria)
}

protocol TipoContasViewControllerDelegate: class {
    func tipoContasViewControllerResponse(tipoConta:TipoConta)
}

protocol ContasViewControllerDelegate: class {
    func contasViewControllerResponse(conta: Conta)
}

protocol ToggleSideMenuDelegate: class {
    func ToggleSideMenu()
}