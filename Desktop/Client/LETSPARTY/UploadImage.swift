//
//  UploadImage.swift
//  LETSPARTY
//
//  Created by LinLin Ding on 10/14/16.
//  Copyright © 2016 LinLin Ding. All rights reserved.
//

import UIKit

//upload image from web browser
class UploadImage: NSObject {
    
    func ImageUploadRequest(_ url:String, partyName:String, partyHolder:String, partyImg:UIImageView)
    {
        let uploadImgUrl=URL(string: url)
        let request=NSMutableURLRequest(url:uploadImgUrl!)
        request.httpMethod="POST"
        
        let param=["partyName":partyName,"partyHolder":partyHolder]
        let boundary=generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let imageData=UIImageJPEGRepresentation(partyImg.image!, 1)
        
        if imageData == nil
        {
            return;
        }
        
        request.httpBody=createBodyWithParameters(param, filePathKey:partyName,imageDataKey:imageData!, boundary: boundary)
        
        let task=URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
                data, response, error in
                
                if error != nil
                {
                    print("error=\(error)")
                }
                let responseString=NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("************ response data=\(responseString!)")
        })            

        
        task.resume()
    }
    
    
    func createBodyWithParameters(_ parameters:[String: String]?, filePathKey: String?, imageDataKey:Data, boundary: String)->Data
    {
        let body=NSMutableData()
        if parameters != nil
        {
            for(key,value) in parameters!
            {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        let prefix = ".jpg"
        let filename=filePathKey!+prefix
        let mimetype="image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type:\(mimetype)\r\n\r\n")
        
        body.append(imageDataKey)
        body.appendString("\r\n")
        body.appendString("--\(boundary)--\r\n")
        return body as Data
    }
    
    
    func generateBoundaryString()->String{
        return "Boundary-\(UUID().uuidString)"
    }
}

extension NSMutableData
{
    func appendString(_ string:String)
    {
        let data=string.data(using: String.Encoding.utf8,allowLossyConversion: true)
        append(data!)
    }
}




