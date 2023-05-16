//
//  StackedViewFlowLayout.swift
//  StackedCV
//
//  Created by Pratham Gupta on 16/05/23.
//

import Foundation
import UIKit

class StackedViewFlowLayout: UICollectionViewFlowLayout {
    
    private var offset: CGPoint = CGPoint(x:0, y: 0)
    private var activeCell: Int
    private let itemWidth: CGFloat
    private let numVisibleItems: Int
    private let slideAdjustment: CGFloat
    private let extraEndCells: Int
    private let extraStartCells: Int
    private let listCount: Int
    
    init(itemWidth: CGFloat, numVisibleItems: Int, listCount: Int, cvWidth: CGFloat) {
        if(itemWidth*CGFloat(numVisibleItems)<cvWidth || numVisibleItems==1) {
            print("Invalid initialization: All items' total width is smaller than collection view's width")
            exit(0)
        }
        self.itemWidth = itemWidth
        self.numVisibleItems = numVisibleItems
        self.listCount = listCount
        slideAdjustment = (cvWidth-itemWidth)/(CGFloat(numVisibleItems)-1)
        extraStartCells = Int(ceil(itemWidth/(2*slideAdjustment) - 1))
        activeCell = extraStartCells
        extraEndCells = Int(ceil((cvWidth-(itemWidth/2)-slideAdjustment)/slideAdjustment))
        offset.x =  CGFloat(activeCell)*slideAdjustment
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        itemSize.width = itemWidth
        itemSize.height = collectionView!.frame.height
        minimumLineSpacing = -(itemSize.width - slideAdjustment)
        collectionView!.contentOffset.x = CGFloat(activeCell)*slideAdjustment
        scrollDirection = .horizontal
        collectionView?.showsHorizontalScrollIndicator = false
        addTapGesture()
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if(proposedContentOffset.x-offset.x>=(itemSize.width/2-1)) {
            setAndUpdateElements(mul: 1)
            zStackSetter(row: activeCell-1)
            backgroundSetter(index: activeCell-1)
        } else if(offset.x-proposedContentOffset.x>=(itemSize.width/2-1)) {
            setAndUpdateElements(mul: -1)
            zStackSetter(row: activeCell+numVisibleItems)
            backgroundSetter(index: activeCell)
        } else {
            return offset
        }
        return CGPoint(x: offset.x, y: proposedContentOffset.y)
    }
}


extension StackedViewFlowLayout {
    
    // MARK: Collection View Delegate Functions
    func getTotalCells() -> Int {
        return extraStartCells+extraEndCells+listCount
    }
    
    func setUpCell(cell: DemoCollectionViewCell) -> DemoCollectionViewCell {
        setSizeAndAlphaScale(cell: cell)
        cell.layer.zPosition = setZStack(row: cell.tag)
        cell.viewInner.backgroundColor = updateCellBackground(index: cell.tag)
        return cell
    }
    
    func updateScrollView() {
        for indexPath in collectionView!.indexPathsForVisibleItems {
            guard let cell = collectionView!.cellForItem(at: indexPath) as? DemoCollectionViewCell else { return }
            setSizeAndAlphaScale(cell: cell)
        }
    }
    
    private func addTapGesture() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.setDidSelectCell))
        tapGR.numberOfTapsRequired = 1
        collectionView!.addGestureRecognizer(tapGR)
    }
    
    // MARK: Helpher Methods
    private func setSizeAndAlphaScale(cell: DemoCollectionViewCell) {
        let scale = (-0.1*(cell.frame.origin.x-collectionView!.contentOffset.x))/slideAdjustment + 1
        cell.updateHeightandTransparency(scale: scale, height: collectionView!.frame.height)
    }
    
    private func setAndUpdateElements(mul: Int) {
        offset.x = offset.x + CGFloat(mul)*slideAdjustment
        activeCell += mul*1
        for i in 0..<numVisibleItems {
            if((activeCell+i)<listCount+extraStartCells) {
                zStackSetter(row: activeCell+i, value: CGFloat(numVisibleItems-i))
            }
        }
    }
    
    private func setZStack(row: Int, value: CGFloat? = nil) -> CGFloat {
        if let zpos = value {
            return zpos
        } else {
            return -CGFloat(abs(extraStartCells-row))
        }
    }
    private func zStackSetter(row: Int, value: CGFloat? = nil) {
        let cell = getCVCellFromRow(row: row)
        cell.layer.zPosition = setZStack(row: row, value: value)
    }
    
    private func updateCellBackground(index: Int) -> UIColor {
        if (index>=extraStartCells && index<extraStartCells+listCount) {
            return viewColor[index%viewColor.count]
        } else {
            return .white
        }
    }
    
    private func backgroundSetter(index: Int) {
        let cell = getCVCellFromRow(row: index)
        cell.viewInner.backgroundColor = updateCellBackground(index: index)
    }
    
    func getCVCellFromRow(row: Int) -> DemoCollectionViewCell {
        return collectionView!.cellForItem(at: IndexPath(row: row, section: 0)) as! DemoCollectionViewCell
    }
    
    // MARK: Tap Actions
    @objc func setDidSelectCell(sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: collectionView)
        if(touchPoint.x-offset.x<=itemWidth) {
            let cell = getCVCellFromRow(row: activeCell)
            cell.printIndex()
        }
    }
}
