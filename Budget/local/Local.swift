//
//  Local.swift
//  Budget
//
//  Created by Yuri Pereira on 4/1/16.
//  Copyright © 2016 Budget Company. All rights reserved.
//

import Foundation
import CoreData


class Local: NSManagedObject {

    static func getLocal() -> Local{
        return ContextFactory.getManagedObject("Local") as! Local
    }
    
    static func getLocaisController(firstSort:String) -> NSFetchedResultsController {
        return ContextFactory.getFetchedResultsController("Local", firstSort: firstSort)
    }
    

}
