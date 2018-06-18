//
//  PinterestLayout.swift
//  Pinterest
//
//  Created by Lolita Chuang on 17/06/2018.
//  Copyright © 2018 Razeware LLC. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate {
//  func collectionViewItemHeight(at indexPath:NSIndexPath) -> CGFloat;
  func collectionView(collectionView: UICollectionView, heightForItemAtIndexPath: NSIndexPath) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {
  var delegate: PinterestLayoutDelegate! // Lolita:不能設定為nil？ = nil
  var numberOfColumn: Int = 1
//  private var cache: [UICollectionViewLayoutAttributes] = []
  private var cache = [UICollectionViewLayoutAttributes]()
  private var contentHeight: CGFloat = 0
  private var width: CGFloat {
    get {
      return collectionView!.bounds.width // Lolita : get每次都會重算嗎?
    }
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override var collectionViewContentSize: CGSize {
    get {
      return CGSize(width: width, height: contentHeight)
//      return CGSize(width: collectionView!.frame.size.width, height: contentHeight)
    }
  }
  
  
  //override func prepareForTransition(to newLayout: UICollectionViewLayout) {
  override func prepare() {
    // Lolita : 算出每一個然後存在cache?
    if cache.isEmpty {
      let columnWidth: CGFloat = width / CGFloat(numberOfColumn)
      
      var xOffsets = [CGFloat]()
      for column in 0..<numberOfColumn {
        xOffsets.append(CGFloat(column) * columnWidth)
      }
      
      // Lolita : 用以算出contentHeight?? 語法?
      var column = 0
      var yOffsets = [CGFloat](repeating: 0, count: numberOfColumn)
      for item in 0..<collectionView!.numberOfItems(inSection: 0) {
        let indexPath = NSIndexPath(item: item, section: 0)
        
        let height = delegate.collectionView(collectionView: collectionView!, heightForItemAtIndexPath: indexPath)
        let frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: height)
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath as IndexPath) // Lolita : 要加 as IndexPath
        attributes.frame = frame
        cache.append(attributes)
        
        contentHeight = max(contentHeight, frame.maxY)
        yOffsets[column] = yOffsets[column] + height
        
        column = (column + 1) % numberOfColumn
      }
    }
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var attributes = [UICollectionViewLayoutAttributes]()
    
    for attribute in cache {
      if attribute.frame.intersects(rect) {
//        attributes.append(attribute.copy() as! UICollectionViewLayoutAttributes)
        attributes.append(attribute )
      }
    }
    
    return attributes
  }
}
