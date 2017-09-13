//
//  PartyInfoController.swift
//  LETSPARTY
//
//  Created by LinLin Ding on 10/16/16.
//  Copyright © 2016 LinLin Ding. All rights reserved.
//

import UIKit

class PartyInfoController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var commentTableView: UITableView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var holder: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var size: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var commentText: UITextField!
    
    let partyInfo:String="http://localhost:3000/partyInfo"
    let writeCommentUrl:String="http://localhost:3000/writeComment"
    

    open var partyInit:String=""
    open var partyHolder:String=""
    open var partyPlace:String=""
    open var partySize:String=""
    open var partyTime:String=""
    
    open var partyImg:UIImage=#imageLiteral(resourceName: "party")
    
    var commentList: Array<Comment>=Array<Comment>()
    
    var refreshControl=UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTableView.dataSource=self
        commentTableView.delegate=self
        
        if #available(iOS 10.0, *)
        {
            print("refresh control")
            commentTableView.refreshControl=self.refreshControl
        }
        else
        {
            // Fallback on earlier versions
        }
        
        self.refreshControl.addTarget(self, action: "didRefreshList", for: .valueChanged)

        name.text=partyInit
        holder.text=partyHolder
        place.text=partyPlace
        time.text=partyTime
        size.text=partySize
        image.image=partyImg

        let network=CommentNetwork()
        network.GetRequest(url: partyInfo, party: partyInit)
        {
            (comments) in
           self.commentList=comments!
           self.do_table_refresh()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
            return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
         let cellId="myCommentCell"
        
         var cell:commentCellTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId) as? commentCellTableViewCell
        
        if(cell == nil)
        {
            cell=commentCellTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
        }
        
        print(".............\(commentList.count)")
        
        if commentList.count>0 && (indexPath as NSIndexPath).row < commentList.count
        {
            cell?.commentFrom.text=self.commentList[(indexPath as NSIndexPath).row].commentFrom
            cell?.commentText.text=self.commentList[(indexPath as NSIndexPath).row].commentText
        }
        
        return cell!
    }
    
    func do_table_refresh()
    {
        DispatchQueue.main.async(execute: {
            self.commentTableView.reloadData()
            return
        })
    }

    func didRefreshList()->Void
    {
        
        CommentNetwork().GetRequest(url: partyInfo, party: partyInit)
        {
            (comments) in
            self.commentList=comments!
        }
        commentTableView.reloadData()
        self.refreshControl.endRefreshing()
        return
        
    }

    @IBAction func WriteComment(_ sender: AnyObject)
    {
        sender.resignFirstResponder()
    }

    @IBAction func ViewTouchDown(_ sender: AnyObject) {
        commentText.resignFirstResponder()
    }

    @IBAction func SendComment(_ sender: AnyObject) {
        let commentFrom:String=UserDefaults.standard.string(forKey: "user")!
        let commentTo:String=partyInit
        let commentText:String=self.commentText.text!
       
        let upLoadMap=["From":commentFrom,"To":commentTo,"Text":commentText]
        
        print(commentFrom,commentTo,commentText)
        
        var throwParty=NetworkClass().UploadRequest(url: writeCommentUrl, uploadMap: upLoadMap,callback: {(response)->Void in
            
            let title = "Write Comment"
            let message = response
            print(message!)
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                let alert = UIAlertController(title: title, message: message, preferredStyle:  .alert)
                let action = UIAlertAction(title: "OK",style: .default,handler: nil)
                
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            })
            
        })
        
        
        
    }
}



