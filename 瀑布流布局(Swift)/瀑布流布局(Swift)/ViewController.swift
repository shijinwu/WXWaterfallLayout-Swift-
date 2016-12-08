//
//  ViewController.swift
//  瀑布流布局(Swift)
//
//  Created by mac on 2016/12/8.
//  Copyright © 2016年 mac. All rights reserved.
//

import UIKit

private let kContentCellID = "kContentCellID"

class ViewController: UIViewController {

    fileprivate lazy var collectionView : UICollectionView = {
        let layout = WXWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        layout.dataSource = self
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
    }
    

    
}

extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        
        cell.backgroundColor = UIColor.randomColor()
        
        return cell
    }
}

extension ViewController : WXWaterfallLayoutDataSource {
    func numberOfCols(_ waterfall: WXWaterfallLayout) -> Int {
        return 4
    }
    
    func waterfall(_ waterfall: WXWaterfallLayout, item: Int) -> CGFloat {
        return CGFloat(arc4random_uniform(150) + 100)
    }
}
