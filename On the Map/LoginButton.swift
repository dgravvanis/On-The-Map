//
//  LoginButton.swift
//  On the Map
//
//  Created by Dimitrios Gravvanis on 4/6/15.
//  Copyright (c) 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit

class LoginButton: UIButton{
    
    // MARK: Properties
    let backingColor = UIColor(red: 0.976, green:0.251, blue:0.0, alpha: 1.0)
    let highlightedBackingColor = UIColor(red: 0.651, green:0.184, blue:0.0, alpha: 1.0)
    
    // MARK: Constructor
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        setTitle("Login", forState: .Normal)
        setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        layer.cornerRadius = 5.0
        backgroundColor = backingColor
    }

    
    // MARK: Touch tracking
    override func beginTrackingWithTouch(touch: UITouch, withEvent: UIEvent) -> Bool {
        
        backgroundColor = highlightedBackingColor
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch, withEvent: UIEvent) {
        
        backgroundColor = backingColor
    }
    
    override func cancelTrackingWithEvent(event: UIEvent?) {
        
        backgroundColor = backingColor
    }
}
