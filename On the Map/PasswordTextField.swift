//
//  PasswordTextField.swift
//  On the Map
//
//  Created by Dimitrios Gravvanis on 6/6/15.
//  Copyright (c) 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit

class PasswordTextField: UITextField {
    
    // Add padding
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10.0, 10.0)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return self.textRectForBounds(bounds)
    }
    
    // Check if text is empty
    func isEmpty() -> Bool {
        
        if text == ""{
            return true
        }else{
            return false
        }
    }
    
    // Shake animation
    func animate() {
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(center.x - 10, center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(center.x + 10, center.y))
        layer.addAnimation(animation, forKey: "position")
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let textAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "AvenirNext-Medium", size: 17)!,
        ]
        
        // Background Appearance
        borderStyle = UITextBorderStyle.None
        backgroundColor = UIColor(red: 0.914, green: 0.667, blue: 0.475, alpha: 1.0)
        
        // Text Attributes
        secureTextEntry = true
        defaultTextAttributes = textAttributes
        textAlignment = NSTextAlignment.Left
        attributedPlaceholder = NSAttributedString(string: "Password", attributes: textAttributes)
        
    }
}

