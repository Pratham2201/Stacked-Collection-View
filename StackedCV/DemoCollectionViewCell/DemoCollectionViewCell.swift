//
//  DemoCollectionViewCell.swift
//  StackedCV
//
//  Created by Pratham Gupta on 16/05/23.
//

import UIKit

let viewColor: [UIColor] = [.red, .blue, .green, .yellow]

class DemoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewInner: UIView!
    @IBOutlet weak var constraintViewInnerHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewInner.isUserInteractionEnabled = true
        viewInner.layer.cornerRadius = 20
    }
    
    func setUpCell(backgroundColor: UIColor, row: Int) {
        viewInner.backgroundColor = backgroundColor
        self.tag = row
    }
    
    func updateHeightandTransparency(scale: CGFloat, height: CGFloat) {
        viewInner.alpha = scale
        constraintViewInnerHeight.constant = scale*height
    }
    
    func printIndex() {
        print(self.tag)
    }

}
