//
//  PopUpCell.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2020-05-20.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import UIKit
import SafariServices

class PopUpCell: UICollectionViewCell {

    @IBOutlet weak var card: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var secondaryButton: UIButton!
    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    var delegate:DevotionalCollectionView!
    var actionURL:String!
    var popUp:PopUp!
    
    func UISetUp() {
        self.card.layer.cornerRadius = 8.0
        self.primaryButton.layer.cornerRadius = 8.0
//        self.primaryButton.frostedDesign()
    }
    
    @IBAction func primaryButtonPressed(_ sender: Any) {

        if let url = URL(string: actionURL) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = delegate

            delegate.present(vc, animated: true) {
                UserDefaultsHelper.addClosedPopUpUPUID(UPUID: self.popUp.UPUID)
                self.popUp.isActive = false
                self.delegate.collectionView.reloadData()
            }
            
        }
        
    }
    
    
    @IBAction func secondaryButtonPressed(_ sender: Any) {
        print("Secondary button pressed")
        
//        self.layoutIfNeeded()
//        heightConstraint.constant = 50
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(translationX: self.layer.bounds.minX - self.layer.bounds.width - 100, y: self.layer.bounds.minY)
            self.layoutIfNeeded()
        }, completion: { (done) in
            
//            if let attributes = self.delegate.collectionView.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) {
//                self.delegate.collectionView.setContentOffset(CGPoint(x: 0, y: attributes.frame.origin.y - self.delegate.collectionView.contentInset.top), animated: true)
//            }
            
//            let indexPath = IndexPath(item: 0, section: 1)
//            self.delegate.collectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
            
            self.popUp.isActive = false
            self.delegate.collectionView.reloadData()
        })
        
       
        
        
    }
    
    @IBAction func morePressed(_ sender: Any) {
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let firstAction: UIAlertAction = UIAlertAction(title: "Do not show again", style: .destructive) { action -> Void in

            UserDefaultsHelper.addClosedPopUpUPUID(UPUID: self.popUp.UPUID)
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.transform = CGAffineTransform(translationX: self.layer.bounds.minX - self.layer.bounds.width - 100, y: self.layer.bounds.minY)
                self.layoutIfNeeded()
            }, completion: { (done) in
                
//                let indexPath = IndexPath(item: 0, section: 1)
//                self.delegate.collectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
                
                self.popUp.isActive = false
                self.delegate.collectionView.reloadData()
            })
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }

        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(cancelAction)

        actionSheetController.popoverPresentationController?.sourceView = moreButton

        delegate.present(actionSheetController, animated: true) {
            print("option menu presented")
        }
    }
    
    //    func primaryButtonPressed(sender: UIButton) {
//        print("Button \(sender.tag) Clicked")
//    }
    
//    @objc func primaryButtonPressed(sender:UIButton!) {
//        print("Tapped it!")
//    }
//
//    @objc func secondaryButtonPressed(sender:UIButton!) {
//        print("Tapped it!")
//    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

        guard isUserInteractionEnabled else { return nil }

        guard !isHidden else { return nil }

        guard alpha >= 0.01 else { return nil }

        guard self.point(inside: point, with: event) else { return nil }


        // add one of these blocks for each button in our collection view cell we want to actually work
        if self.primaryButton.point(inside: convert(point, to: primaryButton), with: event) {
            return self.primaryButton
        }
        
        if self.secondaryButton.point(inside: convert(point, to: secondaryButton), with: event) {
            return self.secondaryButton
        }
        
        if self.moreButton.point(inside: convert(point, to: moreButton), with: event) {
            return self.moreButton
        }

        return super.hitTest(point, with: event)
    }
}
