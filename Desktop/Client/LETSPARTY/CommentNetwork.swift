//
//  CommentNetwork.swift
//  LETSPARTY
//
//  Created by LinLin Ding on 10/21/16.
//  Copyright © 2016 LinLin Ding. All rights reserved.
//

import UIKit

class CommentNetwork: NSObject {
    
    
    
    func GetRequest(url:String, party:String, callback:@escaping ([Comment]?)->Void)
    {
        let parameterString = "requestParty="+party
        let requestURL = URL(string:"\(url)?\(parameterString)")!
        
        print("requestURL is \(requestURL)")
        let request = URLRequest(url:requestURL)
        
        var commentList:[Comment]=[]
        
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        {
            (data, response, error) -> Void in
                if error == nil
                {
                   do
                   {
                    
                    if let jsonArray=try JSONSerialization.jsonObject(with: data!, options: []) as? [[String:Any]]
                    {
                        print("return value is an array")
                        for json in jsonArray
                        {
                            let commentItem=Comment(from:"",to:"",text:"")
                            
                            if let from=json["Comments_From"] as? String
                            {
                                commentItem.commentFrom=from
                            }
                            if let to=json["Comments_To"] as? String
                            {
                                commentItem.commentTo=to
                            }
                            if let text=json["Comments_Text"] as? String
                            {
                                commentItem.commentText=text
                            }

                           
                            commentList.append(commentItem)
                        }
                        callback(commentList)
                    }
                    else if let jsonDic=try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    {
                         print("return value is an dictionary")
                    }
                    
                    
                   }
                   catch
                   {
                    print("2222222222222    JSON ERROR")
                   }
                }

        }
        
        task.resume()
    }
    

    
    
    
    
}
