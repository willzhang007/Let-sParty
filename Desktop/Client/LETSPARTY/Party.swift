//
//  Party.swift
//  LETSPARTY
//
//  Created by LinLin Ding on 10/8/16.
//  Copyright © 2016 LinLin Ding. All rights reserved.
//

import UIKit

 class Party: NSObject {
    
     var partyName: String
     var partyHolder: String
     var partyPlace: String
     var partyTime: String
     var partySize: String
     var partyPicture: String
    
    var commentList=[String]()
    

    
    init(name:String,holder:String,place:String,time:String,size:String,picture:String)
    {
        
        self.partyName=name
        self.partyHolder=holder
        self.partyPlace=place
        self.partyTime=time
        self.partySize=size
        self.partyPicture=picture
    }
}
