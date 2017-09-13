//
//  Comment.swift
//  LETSPARTY
//
//  Created by LinLin Ding on 10/29/16.
//  Copyright © 2016 LinLin Ding. All rights reserved.
//

import UIKit

class Comment: NSObject {
    var commentFrom:String
    var commentTo:String
    var commentText:String
    
    init(from:String,to:String,text:String) {
        self.commentFrom=from
        self.commentTo=to
        self.commentText=text
    }
}
