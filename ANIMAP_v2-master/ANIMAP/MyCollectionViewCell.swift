//
//  MyCollectionViewCell.swift
//  imgscroll
//
//  Created by 謝忠穎 on 2017/7/2.
//  Copyright © 2017年 謝忠穎. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    var imageView:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let w = Double(UIScreen.main.bounds.size.width)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: w/6 - 13.0, height: w/6 - 13.0))
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
