//
//  DefaultCell.swift
//  BottomSheetView
//
//  Created by mtaxi on 2018/8/10.
//  Copyright © 2018年 Tim. All rights reserved.
//

import UIKit

class DefaultCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	static func identify()->String {
		return "DefaultCell"
	}
    
}
