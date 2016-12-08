//
//  WXWaterfallLayout.swift
//  瀑布流布局(Swift)
//
//  Created by mac on 2016/12/8.
//  Copyright © 2016年 mac. All rights reserved.
//

import UIKit

protocol WXWaterfallLayoutDataSource : class {
    func numberOfCols(_ waterfall : WXWaterfallLayout) -> Int
    func waterfall(_ waterfall : WXWaterfallLayout, item : Int) -> CGFloat
}

class WXWaterfallLayout: UICollectionViewFlowLayout {

    weak var dataSource : WXWaterfallLayoutDataSource?
    
    fileprivate lazy var cellAttrs : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    // 多少列
    fileprivate lazy var cols : Int = {
        return self.dataSource?.numberOfCols(self) ?? 2
        
    }()
    
    fileprivate lazy var totalHeights : [CGFloat] = Array(repeatElement(self.sectionInset.top, count: self.cols))
    
    
   
    
}
// MARK: - 准备布局
extension WXWaterfallLayout {
    
    override func prepare() {
        super.prepare()
        
        // Cell --> UICollectionViewLayoutAttributes
        
        // 1. 获取cell的个数
        
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        
        
        let cellW = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - CGFloat(cols - 1)*minimumInteritemSpacing)/CGFloat(cols)
        
        
        for i in 0..<itemCount{
            
            // 1.根据i创建indexPath
            let indexPath = IndexPath(item: i, section: 0)
            
            // 2.根据indexPath创建对应的UICollectionViewLayoutAttributes
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            guard let cellH : CGFloat = dataSource?.waterfall(self, item: i) else {
                 fatalError("请实现对应的数据源方法,并且返回Cell高度")
            }
            
            let minH = totalHeights.min()!
            
            let minIndex = totalHeights.index(of: minH)!
            
            let cellX : CGFloat = sectionInset.left + (minimumInteritemSpacing + cellW) * CGFloat(minIndex)
            let cellY : CGFloat = minH + minimumLineSpacing
            attr.frame = CGRect(x: cellX, y: cellY, width: cellW, height: cellH)
            
            cellAttrs.append(attr)
            
            // 5.添加当前的高度
            totalHeights[minIndex] = minH + minimumLineSpacing + cellH
            
            
        }
        
        
        
    }
    
}

extension WXWaterfallLayout {
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return cellAttrs;
        
    }
  
    
}

extension WXWaterfallLayout {
    
    override var collectionViewContentSize: CGSize {
        
        return CGSize(width: 0, height: totalHeights.max()! + sectionInset.bottom)
    }
    
}

