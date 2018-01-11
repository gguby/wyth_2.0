//
//  TiltingView.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 11..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit


/// 음..사실 TopTiltingView와 유사하지만, 스토리보드에서 바로볼 수 있도록 구현.
@IBDesignable
class TiltingView: UIView {

	@IBInspectable var leftTopGap: CGFloat = 0 {
		didSet {
			self.layoutIfNeeded()
		}
	}
	@IBInspectable var rightTopGap: CGFloat = 20 {
		didSet {
			self.layoutIfNeeded()
		}
	}

	override func draw(_ rect: CGRect) {
		logVerbose("TiltingView DRAW")
		super.draw(rect)

		self.layer.mask = toTiltLayer(getTiltPath(leftTopGap, rightTopGap))
		self.clipsToBounds = true
		self.layer.allowsEdgeAntialiasing = true
		
	}
	
	
	internal func updateAnimateMask(leftGap: CGFloat, rightGap: CGFloat, _ duration: TimeInterval = 0.75) {
		updateAnimateMask(getTiltPath(leftGap, rightGap), duration)
	}

	private func updateAnimateMask(_ newPath: CGPath, _ duration: TimeInterval = 0.75) {
		let mask: CAShapeLayer? = self.layer.mask as? CAShapeLayer
		let anim = CABasicAnimation(keyPath: "path")
		anim.fromValue = mask?.path
		anim.toValue = newPath
		anim.duration = duration
		anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		mask?.add(anim, forKey: nil)
		
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		mask?.path = newPath
		CATransaction.commit()
	}
	
	fileprivate func getTiltPath(_ leftTop: CGFloat, _ rightTop: CGFloat) -> CGPath {
		
		let size = self.frame.size
		logVerbose("path : (top : \(leftTop), \(rightTop) [height:\(size.height)])")
		
		let path = CGMutablePath()
		path.move(to: CGPoint(x: size.width, y: size.height))
		path.addLines(between: [
			CGPoint(x: 0, y: size.height),
			CGPoint(x: 0, y: leftTop),
			CGPoint(x: size.width, y: rightTop),
			CGPoint(x: size.width, y: size.height)
			])
		//path.closeSubpath()
		return path as CGPath
	}
	
	fileprivate func toTiltLayer(_ path: CGPath) -> CALayer {
		let defaultAlpha: CGFloat = 0.8 	// 80% alpha
		if self.backgroundColor == UIColor.clear {
			self.backgroundColor = BSTFacade.theme.color.commonBgPoint().withAlphaComponent(defaultAlpha)
		}
		
		let fillColor: UIColor? = self.backgroundColor
		let strokeColor: UIColor? = self.tintColor
		
		let shapeLayer = CAShapeLayer()
		shapeLayer.path = path
		shapeLayer.fillColor = fillColor?.cgColor
		shapeLayer.strokeColor = strokeColor?.cgColor
		shapeLayer.lineWidth = 3.0
		
		shapeLayer.contentsScale = UIScreen.main.scale
		
		return shapeLayer
	}
	
}
