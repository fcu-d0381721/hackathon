//
//  SecondCollectionViewCell.swift
//  ANIMAP
//
//  Created by Winky_swl on 9/7/2017.
//  Copyright © 2017年 Winky_swl. All rights reserved.
//

import UIKit
import SDWebImage

class BigCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bigImage: UIImageView!
    @IBOutlet weak var city: UILabel!
    
    func configureCell(with URLString: String) {
        
        bigImage.sd_setImage(
            with: URL(string: URLString)!,
            placeholderImage: UIImage(named: "loading")
        )
    }
}
