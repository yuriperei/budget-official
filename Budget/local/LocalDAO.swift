//
//  LocalDAO.swift
//  Budget
//
//  Created by Yuri Pereira on 4/1/16.
//  Copyright © 2016 Budget Company. All rights reserved.
//

import Foundation
import CoreData

class LocalDAO{
    
    func salvar(local:Local) throws {
        try local.managedObjectContext?.save()
    }
    
    func remover(local:Local) throws {
        ContextFactory.getContext().deleteObject(local)
        try ContextFactory.getContext().save()
    }
    
    func getListaReceitas() -> [Local]{
        let fetchRequest = NSFetchRequest(entityName: "Local")
        do {
            let results = try ContextFactory.getContext().executeFetchRequest(fetchRequest)
            return results as! [Local]
        } catch {
            print(error)
        }
        return []
    }
}