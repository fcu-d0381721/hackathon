//
//  ArticleViewTableViewCell.swift
//  ANIMAP
//
//  Created by 謝忠穎 on 2017/7/7.
//  Copyright © 2017年 Winky_swl. All rights reserved.
//

import UIKit

class ArticleViewTableViewCell: UITableViewCell {

    @IBOutlet weak var bodylabel: UILabel!
    
    @IBOutlet weak var floor: UILabel!
    @IBOutlet weak var cardview: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardview.layer.shouldRasterize = true
        cardview.layer.cornerRadius = 10.0; // set cornerRadius as you want.
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
