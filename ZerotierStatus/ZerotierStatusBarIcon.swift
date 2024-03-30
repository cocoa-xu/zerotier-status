//
//  ZerotierStatusBarIcon.swift
//  ZerotierStatus
//
//  Created by Cocoa on 24/03/2024.
//

import Foundation
import AppKit

class ZerotierStatusBarIcon: NSView {
    // original vector image is drawn on a 120.0-by-76.0 canvas
    static let baseWidth: CGFloat  = 120.0
    static let baseHeight: CGFloat = 76.0
    var scaleXMultiplier: CGFloat = 1.0
    var scaleYMultiplier: CGFloat = 1.0
    // proportionally scale by default
    var scaleProportional: Bool = true
    // default is to fit in the view
    var proportionalFill: Bool = false
    
    let iconShapePath: NSBezierPath = {
        let bezierPath = NSBezierPath()
        bezierPath.move(to: NSPoint(x: 95.76, y: 76.06))
        bezierPath.curve(to: NSPoint(x: 93.8, y: 75.2), controlPoint1: NSPoint(x: 95.02, y: 76.03), controlPoint2: NSPoint(x: 94.33, y: 75.73))
        bezierPath.line(to: NSPoint(x: 89.5, y: 70.91))
        bezierPath.curve(to: NSPoint(x: 77.9, y: 66.01), controlPoint1: NSPoint(x: 86.4, y: 67.71), controlPoint2: NSPoint(x: 82.3, y: 66.01))
        bezierPath.curve(to: NSPoint(x: 66.4, y: 70.81), controlPoint1: NSPoint(x: 73.5, y: 66.01), controlPoint2: NSPoint(x: 69.4, y: 67.71))
        bezierPath.line(to: NSPoint(x: 62.1, y: 75.11))
        bezierPath.curve(to: NSPoint(x: 59.4, y: 75.91), controlPoint1: NSPoint(x: 61.4, y: 75.81), controlPoint2: NSPoint(x: 60.3, y: 76.11))
        bezierPath.curve(to: NSPoint(x: 57.2, y: 74.01), controlPoint1: NSPoint(x: 58.4, y: 75.71), controlPoint2: NSPoint(x: 57.6, y: 75.01))
        bezierPath.line(to: NSPoint(x: 37.4, y: 22.7))
        bezierPath.curve(to: NSPoint(x: 39.2, y: 7.2), controlPoint1: NSPoint(x: 35.4, y: 17.6), controlPoint2: NSPoint(x: 36.1, y: 11.8))
        bezierPath.curve(to: NSPoint(x: 40.2, y: 5.91), controlPoint1: NSPoint(x: 39.5, y: 6.8), controlPoint2: NSPoint(x: 39.8, y: 6.31))
        bezierPath.line(to: NSPoint(x: 10.6, y: 5.91))
        bezierPath.curve(to: NSPoint(x: 5.9, y: 10.61), controlPoint1: NSPoint(x: 8, y: 5.91), controlPoint2: NSPoint(x: 5.9, y: 8.01))
        bezierPath.curve(to: NSPoint(x: 7.7, y: 14.31), controlPoint1: NSPoint(x: 5.9, y: 12.01), controlPoint2: NSPoint(x: 6.5, y: 13.41))
        bezierPath.curve(to: NSPoint(x: 11.7, y: 15.2), controlPoint1: NSPoint(x: 8.8, y: 15.21), controlPoint2: NSPoint(x: 10.3, y: 15.5))
        bezierPath.line(to: NSPoint(x: 26.2, y: 12.01))
        bezierPath.curve(to: NSPoint(x: 29.8, y: 14.31), controlPoint1: NSPoint(x: 27.8, y: 11.61), controlPoint2: NSPoint(x: 29.4, y: 12.71))
        bezierPath.curve(to: NSPoint(x: 27.5, y: 17.91), controlPoint1: NSPoint(x: 30.2, y: 15.91), controlPoint2: NSPoint(x: 29.1, y: 17.51))
        bezierPath.line(to: NSPoint(x: 13.1, y: 21.11))
        bezierPath.curve(to: NSPoint(x: 4, y: 19.01), controlPoint1: NSPoint(x: 9.9, y: 21.81), controlPoint2: NSPoint(x: 6.6, y: 21.11))
        bezierPath.curve(to: NSPoint(x: 0, y: 10.61), controlPoint1: NSPoint(x: 1.4, y: 17.01), controlPoint2: NSPoint(x: 0, y: 13.91))
        bezierPath.curve(to: NSPoint(x: 10.6, y: 0.01), controlPoint1: NSPoint(x: -0.1, y: 4.81), controlPoint2: NSPoint(x: 4.7, y: 0.01))
        bezierPath.line(to: NSPoint(x: 52.9, y: 0.01))
        bezierPath.curve(to: NSPoint(x: 55.9, y: 3.01), controlPoint1: NSPoint(x: 54.6, y: 0.01), controlPoint2: NSPoint(x: 55.9, y: 1.31))
        bezierPath.curve(to: NSPoint(x: 52.9, y: 6.01), controlPoint1: NSPoint(x: 55.9, y: 4.71), controlPoint2: NSPoint(x: 54.6, y: 6.01))
        bezierPath.curve(to: NSPoint(x: 44.1, y: 10.7), controlPoint1: NSPoint(x: 49.3, y: 6.01), controlPoint2: NSPoint(x: 46.1, y: 7.7))
        bezierPath.curve(to: NSPoint(x: 42.9, y: 20.61), controlPoint1: NSPoint(x: 42.1, y: 13.7), controlPoint2: NSPoint(x: 41.6, y: 17.31))
        bezierPath.line(to: NSPoint(x: 61, y: 67.61))
        bezierPath.line(to: NSPoint(x: 62.1, y: 66.51))
        bezierPath.curve(to: NSPoint(x: 77.9, y: 60.01), controlPoint1: NSPoint(x: 66.3, y: 62.31), controlPoint2: NSPoint(x: 71.9, y: 60.01))
        bezierPath.curve(to: NSPoint(x: 93.7, y: 66.51), controlPoint1: NSPoint(x: 83.9, y: 60.01), controlPoint2: NSPoint(x: 89.5, y: 62.31))
        bezierPath.line(to: NSPoint(x: 94.8, y: 67.61))
        bezierPath.line(to: NSPoint(x: 112.9, y: 20.61))
        bezierPath.curve(to: NSPoint(x: 111.7, y: 10.7), controlPoint1: NSPoint(x: 114.2, y: 17.31), controlPoint2: NSPoint(x: 113.8, y: 13.6))
        bezierPath.curve(to: NSPoint(x: 102.9, y: 6.01), controlPoint1: NSPoint(x: 109.6, y: 7.8), controlPoint2: NSPoint(x: 106.4, y: 6.01))
        bezierPath.line(to: NSPoint(x: 95.5, y: 6.01))
        bezierPath.curve(to: NSPoint(x: 85.4, y: 13.51), controlPoint1: NSPoint(x: 94.2, y: 10.31), controlPoint2: NSPoint(x: 90.2, y: 13.51))
        bezierPath.curve(to: NSPoint(x: 77.9, y: 10.31), controlPoint1: NSPoint(x: 82.5, y: 13.51), controlPoint2: NSPoint(x: 79.8, y: 12.31))
        bezierPath.line(to: NSPoint(x: 77.8, y: 10.41))
        bezierPath.curve(to: NSPoint(x: 70.4, y: 13.51), controlPoint1: NSPoint(x: 75.8, y: 12.41), controlPoint2: NSPoint(x: 73.2, y: 13.51))
        bezierPath.curve(to: NSPoint(x: 63, y: 10.41), controlPoint1: NSPoint(x: 67.6, y: 13.51), controlPoint2: NSPoint(x: 65, y: 12.41))
        bezierPath.curve(to: NSPoint(x: 59.9, y: 3.01), controlPoint1: NSPoint(x: 61, y: 8.41), controlPoint2: NSPoint(x: 59.9, y: 5.81))
        bezierPath.curve(to: NSPoint(x: 62.9, y: 0.01), controlPoint1: NSPoint(x: 59.9, y: 1.31), controlPoint2: NSPoint(x: 61.2, y: 0.01))
        bezierPath.curve(to: NSPoint(x: 65.9, y: 3.01), controlPoint1: NSPoint(x: 64.6, y: 0.01), controlPoint2: NSPoint(x: 65.9, y: 1.31))
        bezierPath.curve(to: NSPoint(x: 67.2, y: 6.2), controlPoint1: NSPoint(x: 65.9, y: 4.21), controlPoint2: NSPoint(x: 66.4, y: 5.3))
        bezierPath.curve(to: NSPoint(x: 70.4, y: 7.51), controlPoint1: NSPoint(x: 68, y: 7.1), controlPoint2: NSPoint(x: 69.2, y: 7.51))
        bezierPath.curve(to: NSPoint(x: 73.6, y: 6.2), controlPoint1: NSPoint(x: 71.6, y: 7.51), controlPoint2: NSPoint(x: 72.7, y: 7))
        bezierPath.curve(to: NSPoint(x: 74.9, y: 3.11), controlPoint1: NSPoint(x: 74.4, y: 5.4), controlPoint2: NSPoint(x: 74.9, y: 4.31))
        bezierPath.line(to: NSPoint(x: 74.9, y: 3.01))
        bezierPath.line(to: NSPoint(x: 74.9, y: 2.81))
        bezierPath.curve(to: NSPoint(x: 78, y: 0.01), controlPoint1: NSPoint(x: 75, y: 1.21), controlPoint2: NSPoint(x: 76.4, y: -0.09))
        bezierPath.curve(to: NSPoint(x: 80.9, y: 3.01), controlPoint1: NSPoint(x: 79.6, y: 0.01), controlPoint2: NSPoint(x: 80.9, y: 1.41))
        bezierPath.line(to: NSPoint(x: 80.9, y: 3.11))
        bezierPath.curve(to: NSPoint(x: 85.4, y: 7.51), controlPoint1: NSPoint(x: 80.9, y: 5.51), controlPoint2: NSPoint(x: 82.9, y: 7.51))
        bezierPath.curve(to: NSPoint(x: 89.9, y: 3.01), controlPoint1: NSPoint(x: 87.9, y: 7.51), controlPoint2: NSPoint(x: 89.9, y: 5.51))
        bezierPath.curve(to: NSPoint(x: 92.9, y: 0.01), controlPoint1: NSPoint(x: 89.9, y: 1.31), controlPoint2: NSPoint(x: 91.2, y: 0.01))
        bezierPath.line(to: NSPoint(x: 102.9, y: 0.01))
        bezierPath.curve(to: NSPoint(x: 116.7, y: 7.31), controlPoint1: NSPoint(x: 108.4, y: 0.01), controlPoint2: NSPoint(x: 113.6, y: 2.71))
        bezierPath.curve(to: NSPoint(x: 118.5, y: 22.81), controlPoint1: NSPoint(x: 119.8, y: 11.81), controlPoint2: NSPoint(x: 120.5, y: 17.61))
        bezierPath.line(to: NSPoint(x: 98.7, y: 74.11))
        bezierPath.curve(to: NSPoint(x: 96.5, y: 76.01), controlPoint1: NSPoint(x: 98.3, y: 75.01), controlPoint2: NSPoint(x: 97.5, y: 75.71))
        bezierPath.curve(to: NSPoint(x: 95.76, y: 76.06), controlPoint1: NSPoint(x: 96.25, y: 76.06), controlPoint2: NSPoint(x: 96, y: 76.07))
        bezierPath.close()
        bezierPath.move(to: NSPoint(x: 67.9, y: 46.01))
        bezierPath.curve(to: NSPoint(x: 64.9, y: 43.01), controlPoint1: NSPoint(x: 66.25, y: 46.01), controlPoint2: NSPoint(x: 64.9, y: 44.66))
        bezierPath.curve(to: NSPoint(x: 67.9, y: 40.01), controlPoint1: NSPoint(x: 64.9, y: 41.35), controlPoint2: NSPoint(x: 66.25, y: 40.01))
        bezierPath.curve(to: NSPoint(x: 70.9, y: 43.01), controlPoint1: NSPoint(x: 69.56, y: 40.01), controlPoint2: NSPoint(x: 70.9, y: 41.35))
        bezierPath.curve(to: NSPoint(x: 67.9, y: 46.01), controlPoint1: NSPoint(x: 70.9, y: 44.66), controlPoint2: NSPoint(x: 69.56, y: 46.01))
        bezierPath.close()
        bezierPath.move(to: NSPoint(x: 87.9, y: 46.01))
        bezierPath.curve(to: NSPoint(x: 84.9, y: 43.01), controlPoint1: NSPoint(x: 86.25, y: 46.01), controlPoint2: NSPoint(x: 84.9, y: 44.66))
        bezierPath.curve(to: NSPoint(x: 87.9, y: 40.01), controlPoint1: NSPoint(x: 84.9, y: 41.35), controlPoint2: NSPoint(x: 86.25, y: 40.01))
        bezierPath.curve(to: NSPoint(x: 90.9, y: 43.01), controlPoint1: NSPoint(x: 89.56, y: 40.01), controlPoint2: NSPoint(x: 90.9, y: 41.35))
        bezierPath.curve(to: NSPoint(x: 87.9, y: 46.01), controlPoint1: NSPoint(x: 90.9, y: 44.66), controlPoint2: NSPoint(x: 89.56, y: 46.01))
        bezierPath.close()
        return bezierPath
    }()
    
    let iconPathLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = NSColor.textColor.cgColor
        return layer
    }()
    
    func updateScaleMultiplier(_ width: CGFloat, _ height: CGFloat) {
        self.scaleXMultiplier = width  / ZerotierStatusBarIcon.baseWidth;
        self.scaleYMultiplier = height / ZerotierStatusBarIcon.baseHeight;
        if self.scaleProportional {
            let newMultiplier: CGFloat
            if self.proportionalFill {
                newMultiplier = max(self.scaleXMultiplier, self.scaleYMultiplier)
            } else {
                newMultiplier = min(self.scaleXMultiplier, self.scaleYMultiplier)
            }
            self.scaleXMultiplier = newMultiplier
            self.scaleYMultiplier = newMultiplier
        }
        
        let transform = NSAffineTransform.init()
        transform.scaleX(by: self.scaleXMultiplier, yBy: self.scaleYMultiplier)
        
        iconPathLayer.path = transform.transform(iconShapePath).cgPath
    }
    
    func addLayers() {
        self.wantsLayer = true
        self.layer?.addSublayer(iconPathLayer)
    }
    
    override func setFrameSize(_ newSize: NSSize) {
        super.setFrameSize(newSize)
        updateScaleMultiplier(newSize.width, newSize.height)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        updateScaleMultiplier(frameRect.width, frameRect.height)
        addLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addLayers()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        let transform = NSAffineTransform.init()
        transform.scaleX(by: scaleXMultiplier, yBy: scaleYMultiplier)
        iconPathLayer.strokeColor = NSColor.textColor.cgColor
        iconPathLayer.path = transform.transform(iconShapePath).cgPath
    }
}
