//
//  CirclePieView.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2019-11-27.
//  Copyright © 2019 Foothills Alliance Church. All rights reserved.
//

import Foundation
import UIKit

class CirclePieView: UIView {

	var pieFilling:CGFloat! = 0.8
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2 + Double.pi))
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2 + Double.pi))
    }
	
	override func draw(_ rect: CGRect) {

		//In drawRect:
		//Base circle
		
		if pieFilling > 0 {
			if #available(iOS 13.0, *) {
				UIColor.secondarySystemBackground.setFill()
			} else {
				UIColor.clear.setFill()
			}
		} else {
			UIColor.clear.setFill()
		}
		
		let outerPath = UIBezierPath(ovalIn: rect)
		outerPath.fill()

		let viewCenter = CGPoint(x: rect.width / 2, y: rect.height / 2)
	
		if #available(iOS 13.0, *) {
			// None
		} else {
			let corners:UIRectCorner = [.allCorners]
			let radius = rect.width * 0.40
			let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
			let mask = CAShapeLayer()
			mask.path = path.cgPath
			layer.mask = mask
		}
		
		//Semicircles
		let radius = rect.width * 0.40
		let startAngle:CGFloat = 0
		let endAngle:CGFloat = pieFilling * 2 * CGFloat(Double.pi)
		
		Colors.tintColor.setFill()
		if pieFilling < 0.95 {
			let midPath = UIBezierPath()
			midPath.move(to: viewCenter)
			midPath.addArc(withCenter: viewCenter, radius: radius, startAngle: startAngle.degreesToRadians(), endAngle: endAngle, clockwise: true)
			midPath.close()
			midPath.fill()
		}
	}

}
