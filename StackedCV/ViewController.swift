//
//  ViewController.swift
//  StackedCV
//
//  Created by Pratham Gupta on 16/05/23.
//



import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cvDemo: UICollectionView!
    var stackedViewFlowLayout: StackedViewFlowLayout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cvDemo.register(UINib(nibName: "DemoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DemoCollectionViewCell")
        stackedViewFlowLayout = StackedViewFlowLayout(itemWidth: (3*cvDemo.frame.width)/4, numVisibleItems: 5, listCount: 10, cvWidth: cvDemo.frame.width)
        cvDemo.collectionViewLayout = stackedViewFlowLayout!
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stackedViewFlowLayout!.getTotalCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DemoCollectionViewCell", for: indexPath) as? DemoCollectionViewCell else { return DemoCollectionViewCell() }
        cell.tag = indexPath.row
        return stackedViewFlowLayout!.setUpCell(cell: cell)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        stackedViewFlowLayout?.updateScrollView()
    }
}

