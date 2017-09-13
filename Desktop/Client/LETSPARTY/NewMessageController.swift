//
//  NewMessagesController.swift
//  LETSPARTY
//
//  Created by Lichao Zhang on 12/4/16.
//  Copyright © 2016 LinLin Ding. All rights reserved.
//


import UIKit
import Firebase

class NewMessageController: UITableViewController,UISearchBarDelegate,UISearchResultsUpdating{
    
    let cellId = "cellId"
    let newMessagesSearchController = UISearchController(searchResultsController: nil)
    
    var newMessagesRefreshControl=UIRefreshControl()
    var users = [User]()
    var filteredUsers = [User]()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
        //MARK:---------------------
        
        newMessagesSearchController.searchBar.delegate = self
        if #available(iOS 10.0, *) {
            print("refresh control")
            tableView.refreshControl=self.newMessagesRefreshControl
        } else {
            // Fallback on earlier versions
        }
        
        //self.newMessagesRefreshControl.addTarget(self, action: Selector(("didRefreshList")), for: .valueChanged)
        self.newMessagesRefreshControl.addTarget(self, action: "didRefreshList", for: .valueChanged)
        
        
        newMessagesSearchController.searchResultsUpdater = self
        newMessagesSearchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = newMessagesSearchController.searchBar


    }
//MARK:UISearchBar
    
    func newMessagesFilterContentForSearchText(searchText:String,scope:String="All")
    {
//        partiesList=partiesList.filter{Party in
//            return Party.partyName.lowercased().contains(searchText.lowercased())

        filteredUsers = users.filter {
            
            User in return (User.name?.lowercased().contains(searchText.lowercased()))!
        }
            tableView.reloadData()
        print ("filteredUsers")
        print (filteredUsers)
        
    }
    
//    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
//    {
//        NetworkClass().PartyListRequest(url: partyListURL, callBack: partyListCallback)
//        tableView.reloadData()
//    }
    
//    func newMessageupdateSearchResults(for searchController: UISearchController) {
//        newMessagesFiterContentForSearchText(searchText: searchController.searchBar.text!)
//        
//    }
    func updateSearchResults(for searchController: UISearchController){
        newMessagesFilterContentForSearchText(searchText: searchController.searchBar.text!)

    }


    
//    func didRefreshList()->Void
//    {
//        NetworkClass().PartyListRequest(url: partyListURL, callBack: partyListCallback)
//        tableView.reloadData()
//        self.refreshControl.endRefreshing()
//        return
//    }
    

    
    
    
    
//mark:-------------------------------------------------
    
    
    
    
    
    
    
    func fetchUser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.id = snapshot.key
                
                //if you use this setter, your app will crash if your class properties don't exactly match up with the firebase dictionary keys
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                
                //this will crash because of background thread, so lets use dispatch_async to fix
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
                //                user.name = dictionary["name"]
            }
            
        }, withCancel: nil)
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return users.count
//    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newMessagesSearchController.isActive && newMessagesSearchController.searchBar.text != "" {
            return filteredUsers.count
        }
        return users.count
    }
    
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
//        
//        let user = users[(indexPath as NSIndexPath).row]
//        cell.textLabel?.text = user.name
//        cell.detailTextLabel?.text = user.email
//        
//        if let profileImageUrl = user.profileImageUrl {
//            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
//        }
//        
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:cellId, for:indexPath) as! UserCell
        var user = users[(indexPath as NSIndexPath).row]
        if newMessagesSearchController.isActive && newMessagesSearchController.searchBar.text != "" {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
            }
        return cell
        
        
    }
    
    
    
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    var messagesController: MessagesController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            print("Dismiss completed")
            //let user = self.users[(indexPath as NSIndexPath).row]
            //MARK:------------
            let user: User
            if self.newMessagesSearchController.isActive && self.newMessagesSearchController.searchBar.text != "" {
                user = self.filteredUsers[(indexPath as NSIndexPath).row]
            } else {
                user = self.users[(indexPath as NSIndexPath).row]
            }
            self.messagesController?.showChatControllerForUser(user)
        }
    }
//    // MARK: - Segues
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showDetail" {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                let user = users[indexPath.row]
//                let controller = (segue.destination as! UINavigationController).topViewController as! ChatLogController
//
//            }
//        }
//    }
//    
}







