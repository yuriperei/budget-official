//
//  Extensions.swift
//  Budget
//
//  Created by Calebe Santos on 3/31/16.
//  Copyright © 2016 Budget Company. All rights reserved.
//

import Foundation

extension Double {
    var stringValue: String {
        return String(format: "%g", self)
    }
    
    func convertToCurrency(locale:String) -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: locale)
        return (formatter.stringFromNumber(self))!
    }
    
    func removeLastNumber() -> Double {
        return Double(Int(self/10))
    }
    
    func roundDecimal(numberOfDecimals:Double) -> Double {
        let decimalDouble = pow(10.0,numberOfDecimals)
        
        return round(decimalDouble * self) / decimalDouble
    }
}

extension Float {
    var stringValue: String {
        return String(format: "%g", self)
    }
    
    func convertToCurrency(locale:String) -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: locale)
        return (formatter.stringFromNumber(self))!
    }
    
    func removeLastNumber() -> Float {
        return Float(Int(self/10))
    }
}

extension NSDate {
    
    func startOfMonth() -> NSDate? {
        
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([.Month, .Year], fromDate: self)
        
        return calendar.dateFromComponents(dateComponents)
    }
    
    func dateByAddingMonths(monthsToAdd: Int) -> NSDate? {
        
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = NSDateComponents()
        dateComponents.month = monthsToAdd
        
        return calendar.dateByAddingComponents(dateComponents, toDate: self, options: [])
    }
    
    func endOfMonth() -> NSDate? {
        
        let calendar = NSCalendar.currentCalendar()
        
        return calendar.dateByAddingUnit(.Day, value: -1, toDate: self.dateByAddingMonths(1)!, options: [])
    }
}

extension NSNumber {
    func convertToCurrency(locale:String) -> String {
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: locale)
        
        if let currency = formatter.stringFromNumber(self) {
            return currency
        }
        return ""
    }
}

extension String {
    
    var doubleConverter: Double {
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
        
        if let decimalConverter = decimal?.doubleValue {
            return decimalConverter
        }
        
        print("Erro doubleConverter")
        return 0
    }
    
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
    
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
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    var intValue: Int {
        return (self as NSString).integerValue
    }
    
    var lastChar:String {
        if self != "" {
            return self.substringFromIndex((self.endIndex.predecessor()))
        } else {
            return ""
        }
    }
    
    func currencyToDouble() -> Double {
        var result = self
        
        result = result.stringByReplacingOccurrencesOfString("R$",withString:"")
        result = result.stringByReplacingOccurrencesOfString(".",withString:"")
        result = result.stringByReplacingOccurrencesOfString(",",withString:".")
        
        return result.doubleConverter
    }
    
    func currencyToFloat() -> Float {
        var result = self
        
        result = result.stringByReplacingOccurrencesOfString("R$",withString:"")
        result = result.stringByReplacingOccurrencesOfString(".",withString:"")
        result = result.stringByReplacingOccurrencesOfString(",",withString:".")
        
        return result.floatConverter
    }
    
    mutating func removeLastChar() {
        if self != "" {
            self.removeAtIndex(self.endIndex.predecessor())
        }
    }
}

extension UInt32 {
    var intValue:Int? {
        return Int(UnicodeScalarType(self))
    }
}

extension UIImage {
    
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()! as CGContextRef
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        tintColor.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRectMake(0, 0, size.width, size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

/*
Comentários temporário
//    mutating func toFixed(decimal:Double) {
//        let decimalDouble = pow(10.0,decimal)
//
//        self = self / decimalDouble
//    }
*/
