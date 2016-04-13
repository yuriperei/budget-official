//
//  Data.swift
//  Budget
//
//  Created by Yuri Pereira on 3/22/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit

class Data{
    static let dateFormat = NSDateFormatter()
    
    static func formatDateToString(data: NSDate) -> String{
        
        dateFormat.dateFormat = "dd-MM-yyyy"
        return dateFormat.stringFromDate(data)
    }
    
    static func removerTime(data:String) -> NSDate {
        
        dateFormat.dateFormat = "dd-MM-yyyy"
        return dateFormat.dateFromString(data)!
    }
    
    static func sectionFormatarData(name: String) -> String {
        
        let string = name.substringWithRange(Range<String.Index>(start: name.startIndex, end: name.startIndex.advancedBy(10)))
        
        dateFormat.dateFormat = "yyyy-MM-dd"
        let ddd = dateFormat.dateFromString(string)
        
        dateFormat.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormat.timeStyle = NSDateFormatterStyle.NoStyle
        dateFormat.locale = NSLocale(localeIdentifier: "pt-BR")
        
        let dateString = dateFormat.stringFromDate(ddd!)
        
        return dateString
    }
}