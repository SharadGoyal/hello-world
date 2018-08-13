//
//  SignatureView.swift
//  SideMenuDemo
//
//  Created by Sharad Goyal on 13/08/18.
//  Copyright © 2018 Sharad Goyal. All rights reserved.
//

import UIKit

class SignatureView: UIView {
    
    var signatureLabel: UILabel?
    
    @IBInspectable var placeholderText: String?
    @IBInspectable var signatureColor: UIColor?
    @IBInspectable var signatureWidth: CGFloat = 0
    
    let kDeaultColor = UIColor.black
    let kDefaultPlaceholder = "Sign Here"
    let kFontName = "Verdana"
    
    private var beizerPath: UIBezierPath?
    private var points = [CGPoint](repeating: CGPoint.zero, count: 5)
    private var control: Int = 0
    private var shapeLayer: CAShapeLayer?
    private var sigImage: UIImage?
    
    // Create a View which contains Signature Label
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    private func setUpView() {
        
        isMultipleTouchEnabled = false
        beizerPath = UIBezierPath()
        beizerPath?.lineWidth = signatureWidth <= 0 ? 2.0 : signatureWidth
        
        signatureLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        
        if let label = signatureLabel {
            label.numberOfLines = 0
            label.font = UIFont(name: kFontName, size: 60)
            label.text = placeholderText != nil ? placeholderText : kDefaultPlaceholder
            label.textColor = UIColor.lightGray
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.1
            label.alpha = 0.3
            addSubview(label)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        sigImage?.draw(in: rect)
        beizerPath?.stroke()
        
        // Set initial color for drawing
        let fillColor: UIColor? = signatureColor != nil ? signatureColor : kDeaultColor
        fillColor?.setFill()
        let strokeColor: UIColor? = signatureColor != nil ? signatureColor : kDeaultColor
        strokeColor?.setStroke()
        beizerPath?.stroke()
    }
    
    // MARK: - UIView Touch Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if ((signatureLabel?.superview) != nil) {
            signatureLabel?.removeFromSuperview()
        }
        control = 0
        let touch = touches.first
        if let point = touch?.location(in: self) {
            points[0] = point
            let startPoint: CGPoint = points[0]
            let endPoint = CGPoint(x: startPoint.x + 1.5, y: startPoint.y + 2)
            beizerPath?.move(to: startPoint)
            beizerPath?.addLine(to: endPoint)
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let touchPoint: CGPoint? = touch?.location(in: self)
        control += 1
        if let touchPoint = touchPoint {
            points[control] = touchPoint
            if control == 4 {
                points[3] = CGPoint(x: (points[2].x + points[4].x) / 2.0, y: (points[2].y + points[4].y) / 2.0)
                beizerPath?.move(to: points[0])
                beizerPath?.addCurve(to: points[3], controlPoint1: points[1], controlPoint2: points[2])
                setNeedsDisplay()
                points[0] = points[3]
                points[1] = points[4]
                control = 1
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        drawBitmapImage()
        setNeedsDisplay()
        beizerPath?.removeAllPoints()
        control = 0
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    // MARK: - Bitmap Image Creation
    func drawBitmapImage() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        if !(sigImage != nil) {
            let rectpath = UIBezierPath(rect: bounds)
            backgroundColor?.setFill()
            rectpath.fill()
        }
        sigImage?.draw(at: CGPoint.zero)
        //Set final color for drawing
        let strokeColor: UIColor? = signatureColor != nil ? signatureColor : kDeaultColor
        strokeColor?.setStroke()
        beizerPath?.stroke()
        sigImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func clearSignature() {
        sigImage = nil
        if let label = signatureLabel {
            addSubview(label)
        }
        setNeedsDisplay()
    }
    
    func getSignatureImage() -> UIImage? {
        if ((signatureLabel?.superview) != nil) {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let signatureImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return signatureImage
    }
    
}
