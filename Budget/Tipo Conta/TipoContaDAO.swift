//
//  TipoContaDAO.swift
//  Budget
//
//  Created by Yuri Pereira on 4/4/16.
//  Copyright © 2016 Budget Company. All rights reserved.
//

import Foundation
import CoreData

class TipoContaDAO{
    
    func salvar(tipoConta:TipoConta) throws {
        try tipoConta.managedObjectContext?.save()
    }
    
    func remover(tipoConta:TipoConta) throws {
        ContextFactory.getContext().deleteObject(tipoConta)
        try ContextFactory.getContext().save()
    }
    
    func getListaCategorias() -> [TipoConta]{
        let fetchRequest = NSFetchRequest(entityName: "TipoConta")
        do {
            let results = try ContextFactory.getContext().executeFetchRequest(fetchRequest)
            return results as! [TipoConta]
        } catch {
            print(error)
        }
        return []
    }
    
}