//
//  TextoMascara.swift
//  Budget
//
//  Created by Calebe Santos on 3/27/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import Foundation

class FormCustomization {
    
    private static func calculateLabelWidth(label: UILabel) -> CGFloat {
        let labelSize = label.sizeThatFits(CGSize(width: CGFloat.max, height: label.frame.height))
        
        return labelSize.width
    }
    
    private static func calculateMaxLabelWidth(labels: [UILabel]) -> CGFloat {
        //        return reduce(map(labels, calculateLabelWidth), 0, max)
        return labels.map(calculateLabelWidth).reduce(0, combine: max)
    }
    
    static func updateWidthsForLabels(labels: [UILabel]) {
        let maxLabelWidth = calculateMaxLabelWidth(labels)
        for label in labels {
            let constraint = NSLayoutConstraint(item: label,
                attribute: .Width,
                relatedBy: .Equal,
                toItem: nil,
                attribute: .NotAnAttribute,
                multiplier: 1,
                constant: maxLabelWidth)
            label.addConstraint(constraint)
        }
    }
    
    static func dismissInputView(fields:[UITextField]) {
        for field in fields {
            field.resignFirstResponder()
        }
    }
    
    static func aplicarMascara(inout text: String) {
        formatText(&text)
        
        switch text.lastChar {
        case "0","1","2","3","4","5","6","7","8","9":
            break;
        default:
            text.removeLastChar()
        }
        
        if (text.characters.count>7) {
            text.removeLastChar()
        }
        
        text = formatCurrency(text)
    }
    
    
    
    private static func formatText(inout priceS: String) {
        priceS = priceS.stringByReplacingOccurrencesOfString("R$",withString:"")
        priceS = priceS.stringByReplacingOccurrencesOfString(".",withString:"")
        priceS = priceS.stringByReplacingOccurrencesOfString(",",withString:"")
    }
    
    private static func formatCurrency(string: String) -> String{
        let numberFromField = string.floatConverter/100
        return numberFromField.convertToMoedaBr()
    }
}
