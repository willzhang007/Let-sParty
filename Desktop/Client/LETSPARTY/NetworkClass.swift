//
//  NetworkClass.swift
//  LETSPARTY
//
//  Created by LinLin Ding on 10/2/16.
//  Copyright © 2016 LinLin Ding. All rights reserved.
//

import UIKit

//download data from web browser
class NetworkClass: NSObject {
    
    //Upload requrest to server
    func UploadRequest(url: String, uploadMap: Dictionary<String,String>,callback:@escaping (String?)->Void)
    {
        if(JSONSerialization.isValidJSONObject(uploadMap))
        {
            print("is valid json object")
        }
        else{
            print("is invalid json object")
        }

        let uploadData:NSData!=try?JSONSerialization.data(withJSONObject: uploadMap,options: []) as NSData!
        _=NSString(data:uploadData as Data,encoding: String.Encoding.utf8.rawValue)
        let requestNSData:NSData=uploadData
        
        HTTPPostJSON(url: url, data: requestNSData)
        {
            (response, error) -> Void in
            if error != nil
            {
                callback(" error T_T")
                return;
            }
            callback(" success ^_^")
        }
    }
    
    //post json txt to server
    func HTTPPostJSON(url: String,  data: NSData, callback: @escaping (String, String?) -> Void)
    {
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.httpBody = data as Data
        HTTPsendRequest(request: request, callback: callback)
    }
    
    //http send request
    func HTTPsendRequest(request: NSMutableURLRequest, callback: @escaping (String, String?) -> Void)
    {
        let task = URLSession.shared.dataTask(with: request as URLRequest)
            {
                (data, response, error) -> Void in
                if (error != nil)
                {
                    callback("", error!.localizedDescription)
                }
                else
                {
                    callback(NSString(data: data!,encoding: String.Encoding.utf8.rawValue)! as String, nil)
                }
        }
        task.resume()
    }
    
    //request party list to server
    func PartyListRequest(url: String, callBack:@escaping ([Party])->Int)
    {
        var partyList:[Party]=[]
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        let jsonTask = URLSession.shared.dataTask(with: request as URLRequest)
            {
                (data, _, error) -> Void in
                if error == nil
                {
                    do
                    {
                        if let jsonArray=try JSONSerialization.jsonObject(with: data!, options: []) as? [[String:Any]]
                        {
                            for json in jsonArray
                            {
                                 let newParty=Party(name: "", holder: "", place: "", time: "", size: "", picture: "")
                                
                                if let holder=json["Party_holder"] as? String
                                {
                                    newParty.partyHolder=holder
                                }
                                if let name=json["Party_name"] as? String
                                {
                                    newParty.partyName=name
                                }
                                if let place=json["Party_place"] as? String
                                {
                                    newParty.partyPlace=place
                                }
                                if let time=json["Party_time"] as? String
                                {
                                    newParty.partyTime=time
                                }
                                if let size=json["Party_size"] as? String
                                {
                                    newParty.partySize=size
                                }
                                if let picture=json["Party_picture"] as? String
                                {
                                    newParty.partyPicture=picture
                                }
                               partyList.append(newParty)
                            }
                            callBack(partyList)
                        }
                        else if let jsonDic=try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                        {
                          //  print("parse json is dictionary")
                        }
                    }
                    catch
                    {
                        print("json error: \(error)")
                    }
                }
        }
        jsonTask.resume()
    }
    
    func ParseImage(imgurl:String, imageCallback:@escaping (NSData)->Void)
    {
        let url=NSURL(string: imgurl)!
        let request=NSURLRequest(url: url as URL)
        
        let imageTask = URLSession.shared.dataTask(with: request as URLRequest)
        {
            (data, _, error) -> Void in
            if error != nil
            {
                print(error)
                return
            }
            else
            {
                imageCallback(data! as NSData)
            }
        }
        imageTask.resume()
    }
    
}






