//
//  partyCellTableViewCell.swift
//  LETSPARTY
//
//  Created by LinLin Ding on 10/14/16.
//  Copyright © 2016 LinLin Ding. All rights reserved.
//

import UIKit


class partyCellTableViewCell: UITableViewCell {

    @IBOutlet weak var partyImg: UIImageView!
    @IBOutlet weak var partyName: UILabel!
    @IBOutlet weak var partyPlace: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("init cell.....")
     
    }

    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
