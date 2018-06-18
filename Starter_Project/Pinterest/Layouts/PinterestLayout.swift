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
  func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath: NSIndexPath, withWidth: CGFloat) -> CGFloat
  func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath: NSIndexPath, withWidth: CGFloat) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {
  var delegate: PinterestLayoutDelegate? = nil // Lolita:不能設定為nil？ = nil
  var numberOfColumn: Int = 1
//  private var cache: [UICollectionViewLayoutAttributes] = []
  private var cache = [PinterestLayoutAttributes]() // Lolita : 如何lazy? 設定為nil後, 可以重新initialize....? 或繼續append...? 
  private var contentHeight: CGFloat = 0
  
  fileprivate var contentWidth: CGFloat {
    guard let collectionView = collectionView else {
      return 0
    }
    let insets = collectionView.contentInset
    return collectionView.bounds.width - (insets.left + insets.right) // Lolita : 和collectionview是否能左右滑動有關...; 為什麼和collectionView.bounds.width一樣大, 會使得collection view滑動呢?
  }
  
//  private var width: CGFloat {
//    get {
//      return collectionView!.bounds.width // Lolita : get每次都會重算嗎?
//    }
//  }
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
//    self.estimatedItemSize = 210 => flow layout 才有
  }
  
  override var collectionViewContentSize: CGSize {
    get {
      return CGSize(width: contentWidth, height: contentHeight)
//      return CGSize(width: collectionView!.frame.size.width, height: contentHeight)
    }
  }
  
  
  //override func prepareForTransition(to newLayout: UICollectionViewLayout) {
  override func prepare() {
    // Lolita : 算出每一個然後存在cache?
    if cache.isEmpty {
      let columnWidth: CGFloat = contentWidth / CGFloat(numberOfColumn)
      
      var xOffsets = [CGFloat]()
      for column in 0..<numberOfColumn {
        xOffsets.append(CGFloat(column) * columnWidth)
      }
      
      // Lolita : 用以算出contentHeight?? 語法?
      var column = 0
      var yOffsets = [CGFloat](repeating: 0, count: numberOfColumn)
      for item in 0..<collectionView!.numberOfItems(inSection: 0) {
        let indexPath = NSIndexPath(item: item, section: 0)
        
        let photoHeight = delegate?.collectionView(collectionView: collectionView!, heightForPhotoAtIndexPath: indexPath, withWidth: columnWidth) // Lolita : 怎麼寫比較好呢?
        let annotaionHeight = delegate?.collectionView(collectionView: collectionView!, heightForAnnotationAtIndexPath: indexPath, withWidth: columnWidth)
        
        
        let height = 20 + ((photoHeight == nil) ? 0 : photoHeight!) + 10 + ((annotaionHeight == nil) ? 0 : annotaionHeight!) + 20
        print("height : \(height)")
        let frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: height)
        
        let attributes = PinterestLayoutAttributes(forCellWith: indexPath as IndexPath) // Lolita : 要加 as IndexPath
        attributes.photoHeight = height
        attributes.frame = frame
        cache.append(attributes)
        
        contentHeight = max(contentHeight, frame.maxY)
        yOffsets[column] = yOffsets[column] + height
        
        column = (column + 1) % numberOfColumn
      }
    }
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    
    var attributes = [PinterestLayoutAttributes]()
    
    for attribute in cache {
      if attribute.frame.intersects(rect) {
//        attributes.append(attribute.copy() as! PinterestLayoutAttributes)
        attributes.append(attribute )
      }
    }
    
    return attributes
  }
  
  // 因為有custom layout attributes
  override class var layoutAttributesClass: Swift.AnyClass { // override this method to provide a custom class to be used when instantiating instances of UICollectionViewLayoutAttributes
    get {
      return PinterestLayoutAttributes.self
    }
    
  }
}
