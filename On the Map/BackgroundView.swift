//
//  BackgroundView.swift
//  On the Map
//
//  Created by Dimitrios Gravvanis on 4/6/15.
//  Copyright (c) 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit

// Gradient background view
class BackgroundView: UIView {
    
    // Properties for the gradient color
    let startColor = UIColor(red: 0.976, green:0.545, blue:0.0, alpha: 1.0)
    let endColor = UIColor(red: 0.976, green:0.424, blue:0.0, alpha: 1.0)
    
    override func drawRect(rect: CGRect) {
        
        // Get the graphics context
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.CGColor, endColor.CGColor]
        
        // Create rgb color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // Color locations
        let colorLocations:[CGFloat] = [0.0, 1.0]
        
        // Create the gradient
        let gradient = CGGradientCreateWithColors(colorSpace, colors, colorLocations)
        
        // Draw the gradient
        let startPoint = CGPoint.zeroPoint
        let endPoint = CGPoint(x:0, y:self.bounds.height)
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0)

    }
}
