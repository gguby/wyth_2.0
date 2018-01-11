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

//	public func updateDisplayTiltMask(_ heightCCW: CGFloat,
//									  animation: Bool = false,
//									  duration: TimeInterval = 0.75) {
//
//	}
//
	
	/// 0일때 상단에 꽉차는지(y=0) 중간에 오는지(y=height/2)의 여부.
	public var useCenter: Bool = true
	
	
	override func layoutSubviews() {
		super.layoutSubviews()
		// self.updateDisplayTiltMask(0, 0)
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
	public func updateDisplayTiltMask(_ heightCCW: CGFloat,
									  animation: Bool = false,
									  duration: TimeInterval = 0.75) {
		logVerbose("updateDisplayTiltMask: \(heightCCW)")
		if animation {
			if self.layer.mask == nil {
				// 초기값도 세팅되지 않은 녀석이다. 일단 없는쪽에서 출발하도록 설정.
				self.layer.mask = getTiltMaskPercentage(1.0, 1.0)
				self.layer.allowsEdgeAntialiasing = true

			}
			let newPath = self.getTiltPath(heightCCW)
			updateAnimateMask(newPath, duration)
			return
		}
		
		let maskLayer = getTiltMask(heightCCW)
		self.layer.mask = maskLayer
		self.layer.allowsEdgeAntialiasing = true

	}
	
	
	
	/// heightCCW 만으로는 제어가 좀 부족한 경우가 더러 있다.
	/// 양쪽 꼭대기를 직접 제어하는 쪽으로 처리한다.
	///
	/// - Parameters:
	///   - leftTopMaskPercentage: 왼쪽 꼭대기의 좌표 상대값. 제일 위가 0. 제일 아래는 1.0.
	///   - rightTopMaskPercentage: 오른쪽 꼭대기의 좌표 상대값. 제일 위가 0. 제일 아래는 1.0.
	///   - maxHeightLimit: 이 값은 상대값이 아닌 실제 높이값이다.
	///                     leftTopMask, rightTopMask 의 경우 1.0을 입력하면 100%가 깎이는데, 이를 제한할 수 있다.
	///                     예를들어 여기에 값을 40을 주게 되면, mask값이 1.0이더라도 전체를 숨기는게 아닌 40까지만 숨긴다.
	///                     예를들어 100x100 인 사각형에서,  (1.0, 0.0) 을 호출하게되면 왼쪽 1.0, 오른쪽 0.0이 되어 이등변직각삼각형 (오른쪽 아래가 직각)이 되는데,
	///                     (1.0, 0.0, 30) 을 호출하게되면, 왼쪽 위가 30만큼 낮은 사다리꼴이 된다. (하단 두 꼭지점은 당연히 직각. 왼쪽위가 30만큼 낮고 오른쪽 위는 원래높이대로)
	///                     Mask를 직접 사용하는 경우,  useCenter 처리는 생략된다.
	///   - animation: 애니메이션 여부
	///   - duration: 애니메이션 지속 시간
	public func updateDisplayTiltMaskPercentage(_ leftTopMaskPercentage: CGFloat,
												_ rightTopMaskPercentage: CGFloat,
												_ maxHeightLimit: CGFloat? = nil,
												animation: Bool = false,
												duration: TimeInterval = 0.75) {
		
		logVerbose("updateDisplayTiltMaskPercentage: \(leftTopMaskPercentage), \(rightTopMaskPercentage), limit:\(maxHeightLimit)")
		
		if animation {
			if self.layer.mask == nil {
				// 초기값도 세팅되지 않은 녀석이다. 일단 없는쪽에서 출발하도록 설정.
				self.layer.mask = getTiltMaskPercentage(1.0, 1.0)
				self.layer.allowsEdgeAntialiasing = true

			}
			let newPath = self.getTiltPathPercentage(leftTopMaskPercentage, rightTopMaskPercentage, maxHeightLimit)
			updateAnimateMask(newPath, duration)
			return
		}
		
		let maskLayer = getTiltMaskPercentage(1.0, 1.0)
		self.layer.mask = maskLayer
		self.layer.allowsEdgeAntialiasing = true


	}
	

	
	public func getTiltMask(_ heightCCW: CGFloat) -> CAShapeLayer {
		let path = getTiltPath(heightCCW)

		
		
		if self.backgroundColor == UIColor.clear {
			self.backgroundColor = BSTFacade.theme.color.commonBgPoint()
		}

		
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
	
	public func getTiltMaskPercentage(_ leftTopPercentage: CGFloat, _ rightTopPercentage: CGFloat, maxHeightLimit: CGFloat? = nil) -> CAShapeLayer {
		let path = getTiltPathPercentage(leftTopPercentage, rightTopPercentage, maxHeightLimit)
		
		if self.backgroundColor == UIColor.clear {
			self.backgroundColor = BSTFacade.theme.color.commonBgPoint()
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
		
		return getTiltPathDirect(left: leftTop, right: rightTop)
	}
	
	
	internal func getTiltPathPercentage(_ leftTopPercentage: CGFloat, _ rightTopPercentage: CGFloat, _ maxHeightLimit: CGFloat? = nil) -> CGPath {
		
		let maxHeight = maxHeightLimit ?? self.frame.size.height
		
		let leftTop = maxHeight * min(max( 0.0, leftTopPercentage), 1.0)
		let rightTop = maxHeight * min(max( 0.0, rightTopPercentage), 1.0)
		
		return getTiltPathDirect(left: leftTop, right: rightTop)

	}
	
	fileprivate func getTiltPathDirect(left leftTop: CGFloat, right rightTop: CGFloat) -> CGPath {

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
	
	
	/// mask는 기본적으로 애니메이션이 되지않으나,
	/// 다음과 같은 방법으로 가능하다.
	///
	/// refer: https://stackoverflow.com/a/36461202/3381519
	/// - Parameter heightCCW: 반시계방향 기울기 높이차이.
	private func updateAnimateMask(_ newPath: CGPath, _ duration: TimeInterval = 0.75) {
		let mask: CAShapeLayer? = self.layer.mask as? CAShapeLayer
		
		
		let anim = CABasicAnimation(keyPath: "path")
		anim.fromValue = mask?.path
		anim.toValue = newPath
		
		// 지속시간
		anim.duration = duration
		
		// 타입.
		anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		mask?.add(anim, forKey: nil)
		
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		mask?.path = newPath
		CATransaction.commit()

	}
}
