//
//  CustomCell.swift
//  SwiftStudy
//
//  Created by Takuro Mori on 2014/12/02.
//  Copyright (c) 2014年 Takuro Mori. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet var IllustImage : UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
