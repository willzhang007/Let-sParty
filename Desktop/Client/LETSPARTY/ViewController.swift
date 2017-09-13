//
//  ViewController.swift
//  LETSPARTY
//
//  Created by LinLin Ding on 10/2/16.
//  Copyright © 2016 LinLin Ding. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchResultsUpdating{

    @IBOutlet weak var tableView: UITableView!
    
 
    let loginURL:String="http://localhost:3000/login"
    let partyListURL:String="http://localhost:3000/partyList"
    
    var partiesList: Array<Party>=Array<Party>()
    
    var refreshControl=UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        //let image = UIImage(named: "new_message_icon")
        //navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        checkIfUserIsLoggedIn()
        
        tableView.dataSource=self
        tableView.delegate=self
        searchController.searchBar.delegate=self
        if #available(iOS 10.0, *) {
            print("refresh control")
            tableView.refreshControl=self.refreshControl
        } else {
            // Fallback on earlier versions
        }
        
        self.refreshControl.addTarget(self, action: "didRefreshList", for: .valueChanged)
        
        
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        

        
        //request1:
        //send a request to server to authenticate user
        //NetworkClass().LoginRequest(loginURL, userData: user)
        
        //request2:
        //send a request to server to obtain all parties information including txt and json
        NetworkClass().PartyListRequest(url: partyListURL, callBack: partyListCallback)
        
        //request3:
        //send a request to throw a party to web server
    }
    
//    func handleNewMessage() {
//        let newMessageController = NewMessageController()
//        newMessageController.messagesController = self
//        let navController = UINavigationController(rootViewController: newMessageController)
//        present(navController, animated: true, completion: nil)
//    }
    
    
//MARK:-----------------------------------------

    func handleLogout() {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        loginController.viewController = self
        present(loginController, animated: true, completion: nil)
    }
    



    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetupNavBarTitle()
        }
    }
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //                self.navigationItem.title = dictionary["name"] as? String
                
                let user = User()
                user.setValuesForKeys(dictionary)
                //self.setupNavBarWithUser(user)
            }
            
        }, withCancel: nil)
    }
    func showChatControllerForUser(_ user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    

    
//MARK:----------------------------------------------------

    
    
    
    
    func fiterContentForSearchText(searchText:String,scope:String="All")
    {
        if searchController.isActive && searchController.searchBar.text != ""
        {
            partiesList=partiesList.filter{Party in
                return Party.partyName.lowercased().contains(searchText.lowercased())
            }
            tableView.reloadData()
        }
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
         NetworkClass().PartyListRequest(url: partyListURL, callBack: partyListCallback)
         tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        fiterContentForSearchText(searchText: searchController.searchBar.text!)
      
    }
    
    func didRefreshList()->Void
    {
        NetworkClass().PartyListRequest(url: partyListURL, callBack: partyListCallback)
        tableView.reloadData()
        self.refreshControl.endRefreshing()
        return
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != ""
        {
            return partiesList.count
        }
        return partiesList.count;
    }
    
    //MARK:------------------------------------
    
    //show all party list
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId="myTableCell"
        
        var cell:partyCellTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId) as? partyCellTableViewCell
      
        if(cell==nil)
        {
            cell=partyCellTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
        }
    
        if partiesList.count != 0 && (indexPath as NSIndexPath).row < partiesList.count
        {
            cell!.partyName.text=self.partiesList[(indexPath as NSIndexPath).row].partyName
            cell!.partyPlace.text=self.partiesList[(indexPath as NSIndexPath).row].partyPlace
            
            let picture=partiesList[(indexPath as NSIndexPath).row].partyPicture
            
            let picURL:String="http://localhost:3000/"+picture
            let picData=try? Data(contentsOf: URL(string: picURL)!)
            
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high).async(execute: {()-> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    if picData != nil
                    {
                       cell!.partyImg.image=UIImage(data:picData!)
                       cell!.setNeedsLayout() //invalidate current layout
                       cell!.layoutIfNeeded()
                    }
                })
            })
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        tableView.deselectRow(at: indexPath, animated: true)
        
        //let row = (indexPath as NSIndexPath).row
        
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "partyInfo") as! PartyInfoController
        
        destination.partyInit=partiesList[(indexPath as NSIndexPath).row].partyName
        destination.partyHolder=partiesList[(indexPath as NSIndexPath).row].partyHolder
        destination.partyPlace=partiesList[(indexPath as NSIndexPath).row].partyPlace
        destination.partySize=partiesList[(indexPath as NSIndexPath).row].partySize
        destination.partyTime=partiesList[(indexPath as NSIndexPath).row].partyTime
        
        let selectcell :partyCellTableViewCell=tableView.cellForRow(at: indexPath) as! partyCellTableViewCell
        
        //print("............\(selectcell.partyImg.image)")
       

        //print(destination.partyImg)
        destination.partyImg=selectcell.partyImg.image!
        
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
  

    
    func partyListCallback(_ list:[Party])->Int
    {
        partiesList=list

        do_table_refresh("list flag")
        return list.count
    }
    
    
    func do_table_refresh(_ flag:String)
    {
        print("refresh table view"+"      flag is "+flag)
        
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
            return
        })
    }

   


}

