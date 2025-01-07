//
//  CircularProgressView.swift
//  CircularProgressView
//
//  Created by petar on 07.01.2025.
//

import UIKit
import QuartzCore

final class CircularProgressView: UIView {
    
    private let backCircleLayer = CAShapeLayer()
    private let progressCircleLayer = CAShapeLayer()
    
    var colorBackCircle: UIColor = .gray {
        didSet {
            backCircleLayer.strokeColor = colorBackCircle.cgColor
        }
    }
    
    var colorProgressCircle: UIColor = .green {
        didSet {
            progressCircleLayer.strokeColor = colorProgressCircle.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configCircleLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startLoadingAnimation(duration: TimeInterval = 2.0) {
        let loadingAnimation = CABasicAnimation(keyPath: "strokeEnd")
        loadingAnimation.fromValue = 0.0
        loadingAnimation.toValue = 1.0
        loadingAnimation.duration = duration
        loadingAnimation.repeatCount = .greatestFiniteMagnitude
        loadingAnimation.autoreverses = true
        progressCircleLayer.add(loadingAnimation, forKey: "loadingAnimation")
    }
    
    func stopLoadingAnimation() {
        progressCircleLayer.removeAnimation(forKey: "loadingAnimation")
    }
    
    func setValue(value: Float, animated: Bool = true, timeInterval: Float = 1.0) {
        if animated {
            createRatingAnimation(toValue: value, timeInterval: timeInterval)
        } else {
            let clampedValue = min(max(value, 0.0), 1.0)
            progressCircleLayer.strokeEnd = CGFloat(clampedValue)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSizeCircleLayer()
    }
}

private extension CircularProgressView {
    func configCircleLayer() {
        backCircleLayer.fillColor = UIColor.clear.cgColor
        backCircleLayer.strokeColor = colorBackCircle.cgColor
        backCircleLayer.lineCap = .round
        backCircleLayer.lineWidth = 20.0
        backCircleLayer.strokeEnd = 1.0
        
        progressCircleLayer.fillColor = UIColor.clear.cgColor
        progressCircleLayer.strokeColor = colorProgressCircle.cgColor
        progressCircleLayer.lineCap = .round
        progressCircleLayer.lineWidth = 15.0
        progressCircleLayer.strokeEnd = 0.0
        
        self.layer.addSublayer(backCircleLayer)
        self.layer.addSublayer(progressCircleLayer)
    }
    
    func updateSizeCircleLayer() {
        let circleDiameter = min(bounds.width, bounds.height) * 0.5
        let circleRadius = circleDiameter / 2
        let circleCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let circlePath = UIBezierPath(arcCenter: circleCenter,
                                      radius: circleRadius,
                                      startAngle: CGFloat(-0.5 * Double.pi),
                                      endAngle: CGFloat(1.5 * Double.pi),
                                      clockwise: true).cgPath
        
        backCircleLayer.path = circlePath
        progressCircleLayer.path = circlePath
    }
    
    func createRatingAnimation(toValue: Float?, timeInterval: Float) {
        let progressAnimationCircle = CABasicAnimation(keyPath: "strokeEnd")
        progressAnimationCircle.fromValue = 0.0
        progressAnimationCircle.toValue = toValue
        progressAnimationCircle.duration = TimeInterval(floatLiteral: Double(timeInterval))
        progressAnimationCircle.fillMode = .forwards
        progressAnimationCircle.isRemovedOnCompletion = false
        progressCircleLayer.add(progressAnimationCircle, forKey: "animateCircle")
    }
}
