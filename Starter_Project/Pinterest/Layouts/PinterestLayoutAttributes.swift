//
//  PinterestLayoutAttributes.swift
//  Pinterest
//
//  Created by Lolita Chuang on 18/06/2018.
//  Copyright © 2018 Razeware LLC. All rights reserved.
//

import UIKit

class PinterestLayoutAttributes: UICollectionViewLayoutAttributes {
  var photoHeight: CGFloat = 0.0
  
//  required init?(coder aDecoder: NSCoder) {
//    super.init(coder: aDecoder)
//  }
  
  override func copy(with zone: NSZone? = nil) -> Any {
    let copied = super.copy(with: zone) as! PinterestLayoutAttributes
    copied.photoHeight = self.photoHeight
    
    return copied
  }
  
  override func isEqual(_ object: Any?) -> Bool {
//    let isEqual = super.isEqual(object)
//    if isEqual {
//      let attribute = object as! PinterestLayoutAttributes
//      return (photoHeight == attribute.photoHeight)
//    } else {
//      return false
//    }
    
    if let attributes = object as? PinterestLayoutAttributes {
      if (photoHeight == attributes.photoHeight) {
        return super.isEqual(attributes)
      }
    }
//      if super.isEqual(attributes) {
//        return (photoHeight == attribute.photoHeight)
//      } else {
//        return false
//      }
//    } else {
//      return false
//    }
    return false
  }
}
