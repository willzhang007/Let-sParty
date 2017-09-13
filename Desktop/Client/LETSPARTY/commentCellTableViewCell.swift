//
//  commentCellTableViewCell.swift
//  LETSPARTY
//
//  Created by LinLin Ding on 10/29/16.
//  Copyright © 2016 LinLin Ding. All rights reserved.
//

import UIKit

class commentCellTableViewCell: UITableViewCell {

    @IBOutlet weak var commentFrom: UILabel!
    
    @IBOutlet weak var commentText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
