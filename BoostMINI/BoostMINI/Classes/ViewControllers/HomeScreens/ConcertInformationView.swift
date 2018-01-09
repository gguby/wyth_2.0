//
//  ConcertInformationView.swift
//  BoostMINI
//
//  Created by  KoMyeongbu on 2018. 1. 3..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit

class ConcertInformationView: UIView {
    

    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var topTiltingView: TopTiltingView!
    
//    @IBInspectable var fillColor: UIColor = UIColor.gray { didSet { setNeedsLayout() } }
    
    
    class func instanceFromNib() -> ConcertInformationView {
        return UINib(nibName: "InformationView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ConcertInformationView
    }
    
  /*
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        contentView = loadViewFromNib()
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
        
        layoutIfNeeded()
    }
    
    func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "InformationView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
 
 */
    
//    var points = [
//        CGPoint(x: 0, y:0.1),
//        CGPoint(x: 1, y: 0),
//        CGPoint(x: 1, y: 1),
//        CGPoint(x: 0, y: 1)
//        ] { didSet { setNeedsLayout() } }
//    
//    private lazy var shapeLayer: CAShapeLayer = {
//        let _shapeLayer = CAShapeLayer()
//        self.layer.insertSublayer(_shapeLayer, at: 0)
//        return _shapeLayer
//    }()
//    
//    override func layoutSubviews() {
//        shapeLayer.fillColor = fillColor.cgColor
//        
//        guard points.count > 2 else {
//            shapeLayer.path = nil
//            return
//        }
//        
//        let path = UIBezierPath()
//        
//        path.move(to: convert(relativePoint: points[0]))
//        for point in points.dropFirst() {
//            path.addLine(to: convert(relativePoint: point))
//        }
//        path.close()
//        
//        shapeLayer.path = path.cgPath
//    }
//    
//    private func convert(relativePoint point: CGPoint) -> CGPoint {
//        return CGPoint(x: point.x * bounds.width + bounds.origin.x, y: point.y * bounds.height + bounds.origin.y)
//    }
    
}

