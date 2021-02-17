//
//  Extensions.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2019-11-17.
//  Copyright © 2019 Foothills Alliance Church. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    // Give an iOS 11 App Store card view look to a UIView
    func cardDesign() {
        // Round the view corners
        self.layer.cornerRadius = 15.0
    }

	func appIconDesign(selected: Bool) {
		self.layer.cornerRadius = 15.0
		self.layer.borderWidth = 1
		self.layer.borderColor = UIColor.black.cgColor
	}
}

// MARK: - UIButton
extension UIButton {
	func roundDesign() {
		self.backgroundColor = Colors.tintColor
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.cornerRadius = 8.0
    }

    func pillDesign() {
        self.layer.cornerRadius = self.frame.height / 2
    }

	func fadedDesign(with textColor: UIColor? = Colors.tintColor) {
        if #available(iOS 13.0, *) {
            self.backgroundColor = UIColor.secondarySystemBackground
        } else {
            // Fallback on earlier versions
            self.backgroundColor = Colors.fadedColor
        }

		if let imageView = self.imageView {
			imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
			imageView.tintColor = textColor
		}
		self.setTitleColor(textColor, for: .normal)
        self.layer.cornerRadius = 8.0
    }

    func frostedDesign() {
        var textColor: UIColor! = Colors.fadedColor
        if #available(iOS 13.0, *) {
            textColor = UIColor.secondarySystemBackground
        }

        self.setTitleColor(textColor, for: .normal)
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true

        if let viewWithTag = self.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
        let blur = UIVisualEffectView(effect: UIBlurEffect(style:
                    UIBlurEffect.Style.light))
        blur.frame = self.bounds
        blur.isUserInteractionEnabled = false
        blur.layer.cornerRadius = 8.0
        blur.layer.masksToBounds = true
        blur.tag = 100

        self.insertSubview(blur, at: 0)
    }

}

// MARK: - UIImageView
extension UIImageView {
	func roundTopCorners() {
		self.clipsToBounds = true
		self.layer.cornerRadius = 15.0
		let corners: UIRectCorner = [.topRight, .topLeft, .bottomLeft, .bottomRight]
		self.layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
	}
}

// MARK: - UIViewController
extension UIViewController {
    func hideKeyboardWhenTappedAround(doesCancelTouchesInView: Bool) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = doesCancelTouchesInView
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func showAlert(withTitle: String?, message: String?) {
        let alert = UIAlertController(title: withTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    var getTopbarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            // Fallback on earlier versions
            return UIApplication.shared.statusBarFrame.size.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        }
    }
}

// MARK: - UICollectionView
extension UICollectionView {

    func setEmptyView(title: String, message: String) {
		let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
		let titleLabel = UILabel()
		let messageLabel = UILabel()
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		messageLabel.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            titleLabel.textColor = UIColor.label
        } else {
            // Fallback on earlier versions
            titleLabel.textColor = UIColor.black
        }
		titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
		messageLabel.textColor = UIColor.lightGray
		messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
		emptyView.addSubview(titleLabel)
		emptyView.addSubview(messageLabel)
		titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
		titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
		messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
		messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
		messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
		titleLabel.text = title
		messageLabel.text = message
		messageLabel.numberOfLines = 0
		messageLabel.textAlignment = .center
		// The only tricky part is here:
		self.backgroundView = emptyView
	}

    func restore() {
        self.backgroundView = nil
    }
}

// MARK: - UITableView
extension UITableView {

	func hideKeyboardWhenTappedAround(doesCancelTouchesInView: Bool) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UITableView.dismissKeyboard))
        tap.cancelsTouchesInView = doesCancelTouchesInView
        self.addGestureRecognizer(tap)
    }

	@objc func dismissKeyboard() {
		self.endEditing(true)
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }

	func setEmptyView(title: String, message: String) {
		let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
		let titleLabel = UILabel()
		let messageLabel = UILabel()
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		messageLabel.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            titleLabel.textColor = UIColor.label
        } else {
            titleLabel.textColor = UIColor.black
        }
		titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
		messageLabel.textColor = UIColor.lightGray
		messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
		emptyView.addSubview(titleLabel)
		emptyView.addSubview(messageLabel)
		titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
		titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
		messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
		messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
		messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
		titleLabel.text = title
		messageLabel.text = message
		messageLabel.numberOfLines = 0
		messageLabel.textAlignment = .center
		// The only tricky part is here:
		self.backgroundView = emptyView
		self.separatorStyle = .none
	}

}

// MARK: - Float
extension CGFloat {
    func degreesToRadians() -> CGFloat {
        return self * CGFloat(Double.pi) / 180
    }
}
