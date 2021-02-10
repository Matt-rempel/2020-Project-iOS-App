//
//  ProgressPageBLTNItem.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2021-01-08.
//  Copyright © 2021 Foothills Alliance Church. All rights reserved.
//

import UIKit
import BLTNBoard


@objc public class ProgressBulletinPage: BLTNPageItem {

    @objc public var progressView: UIProgressView!

    override public func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        progressView = UIProgressView(progressViewStyle: .bar)
        progressView.setProgress(0.5, animated: true)
        progressView.trackTintColor = UIColor.lightGray
        progressView.tintColor = Colors.tintColor
        
        return [progressView]
    }

    override public func tearDown() {
        super.tearDown()
    }

    override public func actionButtonTapped(sender: UIButton) {
        super.actionButtonTapped(sender: sender)
    }

}
