//
//  Categoria.swift
//  Budget
//
//  Created by Calebe Santos on 3/31/16.
//  Copyright © 2016 Budget Company. All rights reserved.
//

import Foundation
import CoreData


class Categoria: NSManagedObject {

    static func getCategoria() -> Categoria{
        return ContextFactory.getManagedObject("Categoria") as! Categoria
    }
    
    static func getCategoriasController(firstSort:String) -> NSFetchedResultsController {
        return ContextFactory.getFetchedResultsController("Categoria", firstSort: firstSort)
    }

}
