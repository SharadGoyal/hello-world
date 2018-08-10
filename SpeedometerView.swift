//
//  CircleView.swift
//  SideMenuDemo
//
//  Created by Sharad Goyal on 09/08/18.
//  Copyright © 2018 Sharad Goyal. All rights reserved.
//

import Foundation
import UIKit

class SpeedometerView: UIView {
    
    @IBInspectable var firstColor: UIColor = UIColor.red
    @IBInspectable var secondColor: UIColor = UIColor.green
    @IBInspectable var thirdColor: UIColor = UIColor.blue
    
    @IBInspectable public var needleColor: UIColor = UIColor(red: 18/255.0, green: 112/255.0, blue: 178/255.0, alpha: 1.0)
    
    @IBInspectable private var arcWidth: CGFloat = 20
    @IBInspectable var needleValue: CGFloat = 40 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var firstArea: CGFloat = 40.0
    @IBInspectable var secondArea: CGFloat = 30.0
    
    let firstAngle: CGFloat = CGFloat(5 * Double.pi / 6)
    let lastAngle = CGFloat(Double.pi / 6)
    var secondAngle: CGFloat!
    var thirdAngle: CGFloat!
    
    // MARK:- UIView Draw method
    override public func draw(_ rect: CGRect) {
        drawSpeedometer()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        drawSpeedometer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawSpeedometer()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        drawSpeedometer()
    }
    
    
    private func drawSpeedometer() {
        layer.sublayers = []
        drawFirstArc()
        drawSecondArc()
        drawThirdArc()
        drawNeedle()
        drawNeedleCircle()
    }
    
    
    private func drawFirstArc() {
        let bezierPath = UIBezierPath()
        secondAngle = firstAngle + radian(for: firstArea)
        
        bezierPath.addArc(withCenter: CGPoint(x: self.bounds.width/2, y: self.bounds.height/2), radius: self.bounds.width/2 - (arcWidth / 2), startAngle: firstAngle, endAngle: secondAngle, clockwise: true)
        bezierPath.lineWidth = arcWidth
        firstColor.setStroke()
        bezierPath.stroke()
    }
    
    private func drawSecondArc() {
        thirdAngle = secondAngle + radian(for: secondArea)
        let bezierPath = UIBezierPath()
        
        bezierPath.addArc(withCenter: CGPoint(x: self.bounds.width/2, y: self.bounds.height/2), radius: self.bounds.width/2 - (arcWidth / 2), startAngle: secondAngle, endAngle: thirdAngle, clockwise: true)
        bezierPath.lineWidth = arcWidth
        secondColor.setStroke()
        bezierPath.stroke()
    }
    
    private func drawThirdArc() {
        
        let bezierPath = UIBezierPath()
        
        bezierPath.addArc(withCenter: CGPoint(x: self.bounds.width/2, y: self.bounds.height/2), radius: self.bounds.width/2 - (arcWidth / 2), startAngle: thirdAngle, endAngle: lastAngle, clockwise: true)
        bezierPath.lineWidth = arcWidth
        thirdColor.setStroke()
        bezierPath.stroke()
    }
    
    private func drawNeedle() {
        // 1
        
        let triangleLayer = CAShapeLayer()
        let shadowLayer = CAShapeLayer()
        
        // 2
        triangleLayer.frame = bounds
        shadowLayer.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y + 5, width: bounds.width, height: bounds.height)
        
        // 3
        let needlePath = UIBezierPath()
        needlePath.move(to: CGPoint(x: self.bounds.width * 0.12, y: self.bounds.width * 0.72))
        needlePath.addLine(to: CGPoint(x: self.bounds.width * 0.565, y: self.bounds.width * 0.42))
        needlePath.addLine(to: CGPoint(x: self.bounds.width * 0.6, y: self.bounds.width * 0.48))
        needlePath.close()
        
        // 4
        triangleLayer.path = needlePath.cgPath
        shadowLayer.path = needlePath.cgPath
        
        // 5
        triangleLayer.fillColor = needleColor.cgColor
        triangleLayer.strokeColor = needleColor.cgColor
        shadowLayer.fillColor = UIColor.lightGray.withAlphaComponent(0.1).cgColor
        
        // 6
        layer.addSublayer(shadowLayer)
        layer.addSublayer(triangleLayer)
        
        animate(triangleLayer: triangleLayer, shadowLayer: shadowLayer, fromValue: 0, toValue: needleValue+10, duration: 0.5) {
            self.animate(triangleLayer: triangleLayer, shadowLayer: shadowLayer, fromValue: self.needleValue+10, toValue: self.needleValue-10, duration: 0.4, callBack: {
                self.animate(triangleLayer: triangleLayer, shadowLayer: shadowLayer, fromValue: self.needleValue-10, toValue: self.needleValue, duration: 0.6, callBack: {})
            })
        }
    }
    
    private func animate(triangleLayer: CAShapeLayer, shadowLayer:CAShapeLayer, fromValue: CGFloat, toValue:CGFloat, duration: CFTimeInterval, callBack:@escaping ()->Void) {
        // 1
        CATransaction.begin()
        let spinAnimation1 = CABasicAnimation(keyPath: "transform.rotation.z")
        spinAnimation1.fromValue = radian(for: fromValue)
        spinAnimation1.toValue = radian(for: toValue)
        spinAnimation1.duration = duration
        spinAnimation1.fillMode = kCAFillModeForwards
        spinAnimation1.isRemovedOnCompletion = false
        
        CATransaction.setCompletionBlock {
            callBack()
        }
        // 2
        triangleLayer.add(spinAnimation1, forKey: "indeterminateAnimation")
        shadowLayer.add(spinAnimation1, forKey: "indeterminateAnimation")
        CATransaction.commit()
    }
    
    private func radian(for area: CGFloat) -> CGFloat {
        let degrees = 2.4 * area // Entire Arc is of 240 degrees
        let radians = degrees * .pi/180
        return radians
    }
    
    private func drawNeedleCircle() {
        // 1
        let circleLayer = CAShapeLayer()
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2), radius: self.bounds.width/20, startAngle: 0.0, endAngle: CGFloat(2 * Double.pi), clockwise: false)
        // 2
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.black.cgColor
        layer.addSublayer(circleLayer)
    }
    
}
