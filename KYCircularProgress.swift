//
//  KYCircularProgress.swift
//  NakedChinese
//
//  Created by IMAC  on 15.02.15.
//  Copyright (c) 2015 Dmitriy Karachentsov. All rights reserved.
//

//
//  KYCircularProgress.swift
//  NakedChinese
//
//  Created by IMAC  on 15.02.15.
//  Copyright (c) 2015 Dmitriy Karachentsov. All rights reserved.
//

//
//  KYCircularProgress.swift
//  KYCircularProgress
//
//  Created by Y.K on 2014/10/02.
//  Copyright (c) 2014年 Yokoyama Kengo. All rights reserved.
//

import Foundation
import UIKit

// MARK: - KYCircularProgress
class KYCircularProgress: UIView {
    typealias progressChangedHandler = (_ progress: Double, _ circularView: KYCircularProgress) -> ()
    let kShapeViewAnimation = "kShapeViewAnimation"
    var progressChangedClosure: progressChangedHandler?
    var progressView: KYCircularShapeView!
    var progressDifference = 0
    var gradientLayer: CAGradientLayer!
    var progress: Double = 0.0 {
        didSet(newValue) {
            let clipProgress = max( min(newValue, 1.0), 0.0)
            self.progressView.updateProgress(clipProgress)
            
            if let progressChanged = progressChangedClosure {
                progressChanged(clipProgress, self)
            }
        }
    }
    var startAngle: Double = 0.0 {
        didSet {
            self.progressView.startAngle = self.startAngle
        }
    }
    var endAngle: Double = 0.0 {
        didSet {
            self.progressView.endAngle = self.endAngle
        }
    }
    var lineWidth: Double = 8.0 {
        didSet {
            self.progressView.shapeLayer().lineWidth = CGFloat(self.lineWidth)
        }
    }
    var path: UIBezierPath? {
        didSet {
            self.progressView.shapeLayer().path = self.path?.cgPath
        }
    }
    var colors: [AnyObject]? {
        didSet {
            self.gradientLayer.colors = self.colors
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        self.progressView = KYCircularShapeView(frame: self.bounds)
        self.progressView.shapeLayer().fillColor = UIColor.clear.cgColor
        self.progressView.shapeLayer().path = self.path?.cgPath
        
        gradientLayer = CAGradientLayer(layer: layer)
        gradientLayer.frame = self.progressView.frame
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5);
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5);
        gradientLayer.mask = self.progressView.shapeLayer();
        gradientLayer.colors = self.colors ?? [colorHex(0x9ACDE7).cgColor, colorHex(0xE7A5C9).cgColor]
        
        self.layer.addSublayer(gradientLayer)
        self.progressView.shapeLayer().strokeColor = self.tintColor.cgColor
    }
    
    func progressChangedBlock(_ completion: @escaping progressChangedHandler) {
        progressChangedClosure = completion
    }
    
    func colorHex(_ rgb: Int) -> UIColor {
        return UIColor(red: CGFloat((rgb & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgb & 0xFF00) >> 8)/255.0,
            blue: CGFloat(rgb & 0xFF)/255.0,
            alpha: 0.55)
    }
}

// MARK: - KYCircularShapeView
class KYCircularShapeView: UIView {
    var startAngle = 0.0
    var endAngle = 0.0
    
    override class var layerClass : AnyClass {
        return CAShapeLayer.self
    }
    
    func shapeLayer() -> CAShapeLayer {
        return self.layer as! CAShapeLayer
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.updateProgress(0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.startAngle == self.endAngle {
            self.endAngle = self.startAngle + M_PI * 2
        }
        self.shapeLayer().path = self.shapeLayer().path ?? self.layoutPath().cgPath
    }
    
    func layoutPath() -> UIBezierPath {
        let halfWidth = CGFloat(self.frame.size.width / 2.0)
        return UIBezierPath(arcCenter: CGPoint(x: halfWidth, y: halfWidth), radius: halfWidth - self.shapeLayer().lineWidth, startAngle: CGFloat(self.startAngle), endAngle: CGFloat(self.endAngle), clockwise: true)
    }
    
    func updateProgress(_ progress: Double) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        self.shapeLayer().strokeEnd = CGFloat(progress)
        CATransaction.commit()
    }
}

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net
