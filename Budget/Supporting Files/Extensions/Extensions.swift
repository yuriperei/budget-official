//
//  Extensions.swift
//  Budget
//
//  Created by Calebe Santos on 3/31/16.
//  Copyright © 2016 Budget Company. All rights reserved.
//

import Foundation

extension String {
    var floatConverter: Float {
        let converter = NSNumberFormatter()
        converter.decimalSeparator = "."
        
        var decimal:NSNumber?
        
        if let result = converter.numberFromString(self) {
            decimal = result
        } else {
            converter.decimalSeparator = ","
            if let result = converter.numberFromString(self) {
                decimal = result
            }
        }
        
        if let decimalConverter = decimal?.floatValue {
            return decimalConverter
        }
        
        print("Erro floatConverter")
        return 0
    }
    
    func floatConverterMoeda() -> Float {
        var result = self
        
        result = result.stringByReplacingOccurrencesOfString("R$",withString:"")
        result = result.stringByReplacingOccurrencesOfString(".",withString:"")
        result = result.stringByReplacingOccurrencesOfString(",",withString:".")
        
        return result.floatConverter
    }
    
    var lastChar:String {
        if self != "" {
            return self.substringFromIndex((self.endIndex.predecessor()))
        } else {
            return ""
        }
    }
    mutating func removeLastChar() {
        if self != "" {
            self.removeAtIndex(self.endIndex.predecessor())
        }
    }
}

extension Float {
    func convertToMoedaBr() -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "pt_BR")
        return (formatter.stringFromNumber(self))!
    }
    
    func removeLastNumber() -> Float {
//        return (self - (self % 10))/10
        return Float(Int(self/10))
    }
}

extension NSDate {
    
    func startOfMonth() -> NSDate? {
        
        let calendar = NSCalendar.currentCalendar()
        let currentDateComponents = calendar.components([.Month, .Year], fromDate: self)
        let startOfMonth = calendar.dateFromComponents(currentDateComponents)
        
        return startOfMonth
    }
    
    func dateByAddingMonths(monthsToAdd: Int) -> NSDate? {
        
        let calendar = NSCalendar.currentCalendar()
        let months = NSDateComponents()
        months.month = monthsToAdd
        
        return calendar.dateByAddingComponents(months, toDate: self, options: [])
    }
    
    func endOfMonth() -> NSDate? {
        
        let calendar = NSCalendar.currentCalendar()
        return calendar.dateByAddingUnit(.Day, value: -1, toDate: self.dateByAddingMonths(1)!, options: [])
        
        //        return nil
    }
}