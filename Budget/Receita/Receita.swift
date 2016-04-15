//
//  Receita.swift
//  Budget
//
//  Created by Calebe Santos on 3/31/16.
//  Copyright © 2016 Budget Company. All rights reserved.
//

import Foundation
import CoreData


class Receita: NSManagedObject {

    static func getReceita() -> Receita{
        return ContextFactory.getManagedObject("Receita") as! Receita
    }
    
    static func getReceitasController(firstSort:String, secondSort:String = "", sectionName:String) -> NSFetchedResultsController {
        return ContextFactory.getFetchedResultsController("Receita", firstSort: firstSort, secondSort: secondSort, ascending: false, sectionName: sectionName)
    }

}
