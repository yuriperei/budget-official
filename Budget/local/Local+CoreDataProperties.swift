//
//  Local+CoreDataProperties.swift
//  Budget
//
//  Created by Yuri Pereira on 4/1/16.
//  Copyright © 2016 Budget Company. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Local {

    @NSManaged var nome: String?
    @NSManaged var cidade: String?
    @NSManaged var estado: String?
    @NSManaged var rua: String?
    @NSManaged var despesa: NSSet?
    @NSManaged var receita: NSSet?

}
