//
//  HomeCell.swift
//  ANIMAP
//
//  Created by Winky_swl on 8/7/2017.
//  Copyright © 2017年 Winky_swl. All rights reserved.
//

import UIKit
import SDWebImage

class HomeCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var coverView: UIView!

    @IBOutlet weak var city: UILabel!
    
    func configureCell(with URLString: String) {
        
        imageView.sd_setImage(
            with: URL(string: URLString)!,
            placeholderImage: UIImage(named: "loading")
        )        
    }
    

    
}
