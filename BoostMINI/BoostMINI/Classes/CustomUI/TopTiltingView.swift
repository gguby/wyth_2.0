//
//  TopTiltingView.swift
//  BoostMINI
//
//  Created by jack on 2018. 1. 3..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift


class TopTiltingView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	
	
	/// 0일때 상단에 꽉차는지(y=0) 중간에 오는지(y=height/2)의 여부.
	public var useCenter: Bool = true
	
	override func willMove(toSuperview newSuperview: UIView?) {
		
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.updateDisplayTiltMask(-20)
	}
	
	/// 기울기에 의한 마스크 반환
	///
	/// - Parameter heightCCW: 시계 반대방향 기준의 높이임.
	///                        이 값이 54일 경우, 54높이의 뷰 패쓰가 만들어진다.
	///                        높이가 108이고 54을 적용한 뷰는 대략 다음과 같다.
	///                              +-+   오른쪽 높이 108    (81 + 54/2)
	///                           +-+  |   중앙의 높이 81     (뷰 높이 108 - 54/2)
	///                        +-+     |   왼쪽  높이 54     (81 - 54/2)
	///                        |       |
	///                        |       |
	///                        +-------+   높이 0 지점.
	///                        즉 해당 값만큼 내려가지게된다.
	///                        음수일 경우 반대로 오른쪽이 더 낮은 결과가 나온다.
	///                        이 높이는 뷰의 높이보다 클 수 없다. 초과분은 무시된다.
	///                        예) 뷰의 높이가 100일 경우, heightCCW의 최대값은 뷰 높이인 100이되며, 200을 입력해도 100으로 처리된다.
	///                           100이 들어갈 경우, 오른쪽이 직각인 직각삼각형이 만들어지며     /|
	///                          -100이 들어갈 경우, 왼쪽이 직각인 직각삼각형이 만들어진다.  |\
	///                          뷰의 폭도 100일 경우, 가로 세로 길이가 같은 이등변직각삼각형이 될 것이다.
	///   - animation: true로할 경우 애니메이션이 된다. updateAnimateMask에서 그 값을찾아볼수있다
	public func updateDisplayTiltMask(_ heightCCW: CGFloat, animation: Bool = false) {
		logVerbose("updateDisplayTiltMask: \(heightCCW)")
		if self.layer.mask != nil && animation == true {
			updateAnimateMask(heightCCW)
			return
		}
		
		let maskLayer = getTiltMask(heightCCW)
		self.layer.mask = maskLayer
	}
	
	public func getTiltMask(_ heightCCW: CGFloat) -> CAShapeLayer {
		let path = getTiltPath(heightCCW)

		if self.backgroundColor == UIColor.clear {
			self.backgroundColor = UIColor("#91001a")
		}

		//let fillColor: UIColor? = heightCCW <= 0 ? UIColor("#bcabef") : UIColor("#91001a")
		let fillColor: UIColor? = self.backgroundColor
		let strokeColor: UIColor? = self.tintColor
		
		let shapeLayer = CAShapeLayer()
		shapeLayer.path = path
		shapeLayer.fillColor = fillColor?.cgColor
		shapeLayer.strokeColor = strokeColor?.cgColor
		shapeLayer.lineWidth = 3.0
		
		shapeLayer.contentsScale = UIScreen.main.scale
		
		
//		shapeLayer.fillRule = kCAFillRuleNonZero

		return shapeLayer
	}

	/// getTileMask의 내부. CGPath를 반환한다.
	internal func getTiltPath(_ heightCCW: CGFloat) -> CGPath {
		let size = self.frame.size
		let viewHeight = self.frame.height
		let tiltHeight = min(max( -viewHeight, heightCCW), viewHeight)
		
		
		var middleFix: CGFloat = 0

		if useCenter {
			let middle = viewHeight * 0.5
			middleFix = middle
			let distance: CGFloat = abs(tiltHeight)
			middleFix = (viewHeight - distance) * 0.5
		}

		let leftTop = ((tiltHeight <= 0) ? 0 : tiltHeight) + middleFix
		let rightTop = ((tiltHeight >= 0) ? 0 : -tiltHeight) + middleFix
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
	
	
	/// mask는 기본적으로 애니메이션이 되지않으나,
	/// 다음과 같은 방법으로 가능하다.
	///
	/// refer: https://stackoverflow.com/a/36461202/3381519
	/// - Parameter heightCCW: 반시계방향 기울기 높이차이.
	private func updateAnimateMask(_ heightCCW: CGFloat) {
		let mask: CAShapeLayer? = self.layer.mask as? CAShapeLayer
		
		let newPath = self.getTiltPath(heightCCW)
		
		let anim = CABasicAnimation(keyPath: "path")
		anim.fromValue = mask?.path
		anim.toValue = newPath
		
		// 지속시간
		anim.duration = 0.75
		
		// 타입.
		anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		mask?.add(anim, forKey: nil)
		
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		mask?.path = newPath
		CATransaction.commit()

	}
}
