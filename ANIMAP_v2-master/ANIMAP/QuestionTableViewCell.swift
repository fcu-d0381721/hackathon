//
//  QuestionTableViewCell.swift
//  ANIMAP
//
//  Created by 謝忠穎 on 2017/7/6.
//  Copyright © 2017年 Winky_swl. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {


    @IBOutlet weak var cardview: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var bgimage: UIImageView!
    @IBOutlet weak var cate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 16)
        
    
        cardview.backgroundColor = UIColor(white: 0.4, alpha: 1)
        cardview.layer.shadowColor = UIColor.black.cgColor
        cardview.layer.shadowOpacity = 0.4
        cardview.layer.shadowOffset = CGSize(width: 2, height: 2)
        cardview.layer.shadowRadius = 3
        cardview.layer.shouldRasterize = true
        


 

        cardview.layer.cornerRadius = 10.0; // set cornerRadius as you want.
        

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
