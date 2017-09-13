//
//  ThrowPartyViewController.swift
//  LETSPARTY
//
//  Created by LinLin Ding on 10/14/16.
//  Copyright © 2016 LinLin Ding. All rights reserved.
//

import UIKit

class ThrowPartyViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource
 {
    let upLoadImgUrl:String="http://localhost:3000/uploadpic"
    let throwPartyUrl:String="http://localhost:3000/throwParty"
    let size = ["below 5","5-10","10-15","15-20","20-25","25-50","no limits"]
    var dateFormatter : DateFormatter!
    var pickerView = UIPickerView()
    var datePicker = UIDatePicker()
    var datePicker2 = UIDatePicker()
    @IBOutlet weak var PartyName: UITextField!
    @IBOutlet weak var PartyHolder: UITextField!
    @IBOutlet weak var PartyPlace: UITextField!
    @IBOutlet weak var PartyTime: UITextField!
    @IBOutlet weak var PartySize: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var PartyTime2: UITextField!

    @IBOutlet weak var Description: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        //view.addSubview(ThrowPartyBackgroundView)
        //MARK:---------------------------
        
        
        
        
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        datePicker2.datePickerMode = UIDatePickerMode.dateAndTime
        //self.view.addSubview(datePicker)
       
        datePicker.addTarget(self, action:  #selector(ThrowPartyViewController.handleDatePicker(_:)), for:UIControlEvents.valueChanged)
        datePicker2.addTarget(self, action:  #selector(ThrowPartyViewController.handleDatePicker2(_:)), for:UIControlEvents.valueChanged)
        
//MARK:size picker -------------------------------
        pickerView.dataSource = self;
        pickerView.delegate = self;
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ThrowPartyViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ThrowPartyViewController.donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        PartySize.inputView = pickerView
        PartySize.inputAccessoryView = toolBar
        //PartyTime.inputView = datePicker
        //PartyTime.inputAccessoryView = toolBar
        PartyTime.inputView = datePicker;
        PartyTime.inputAccessoryView = toolBar
        PartyTime2.inputView = datePicker2;
        PartyTime2.inputAccessoryView = toolBar

    }
//    @IBAction func dateTextInputPressed(_ sender: UITextField) {
//        
//        //Create the view
//        let inputView = UIView(frame: CGRect(x:0, y:0, width: 240,height:200))
//        
//        
//        var datePickerView  : UIDatePicker = UIDatePicker(frame: CGRect(x:0, y:40, width:0, height:0))
//        datePickerView.datePickerMode = UIDatePickerMode.date
//        inputView.addSubview(datePickerView) // add date picker to UIView
//        
//        //let doneButton = UIButton(frame: CGRect((self.view.frame.size.width/2) - (100/2), 0, 100, 50))
//        doneButton.setTitle("Done", for: UIControlState.normal)
//        doneButton.setTitle("Done", for: UIControlState.highlighted)
//        doneButton.setTitleColor(UIColor.black, for: UIControlState.normal)
//        doneButton.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
//        
//        inputView.addSubview(doneButton) // add Button to UIView
//        
//        doneButton.addTarget(self, action: "doneButton:", for: UIControlEvents.touchUpInside) // set button click event
//        
//        sender.inputView = inputView
//        datePickerView.addTarget(self, action: #selector(ThrowPartyViewController.handleDatePicker(_:)), for: UIControlEvents.valueChanged)
//        
//        handleDatePicker(datePickerView) // Set the date on start.
//    }
    func handleDatePicker(_ sender: UIDatePicker){
        //show date in label
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd  HH:mm"
        
        PartyTime.text = dateFormatter.string(from: sender.date)
        //print ("OK")
    
    }
    func handleDatePicker2(_ sender: UIDatePicker){
        //show date in label
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd  HH:mm"
        
        PartyTime2.text = dateFormatter.string(from: sender.date)
        //print ("OK")
        
    }
    
    func donePicker ()
    {
       //PartySize.resignFirstResponder()
        self.view.endEditing(true)
    }
    
//    @IBAction func datePickerChangeAction(_ sender: UIDatePicker) {
//    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int  {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return size.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return size[row]
    }
    //MARK:------------------------
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        PartySize.text = size[row]
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = self.size[row]
        
        pickerLabel.font = UIFont(name: "Helvetica", size: 25) // customize font
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    

    
    
    
    
    
    
    
    
    
    //MARK:------------------------------------------------
    //select a photo from local
    @IBAction func SelectPhotoTapped(_ sender: AnyObject)
    {
        let myPickerController=UIImagePickerController()
        myPickerController.delegate=self
        myPickerController.sourceType=UIImagePickerControllerSourceType.photoLibrary
        present(myPickerController, animated: false,completion: nil)
    }
    let ThrowPartyBackgroundView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named:"throw-party-background")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        photoImageView.image=image
        self.dismiss(animated: true,completion:nil)
        
    }
    
    @IBAction func UploadPhotoTapped(_ sender: AnyObject)
    {
        print("upload button has been clicked")
        let upLoad=UploadImage()
        upLoad.ImageUploadRequest(upLoadImgUrl, partyName: PartyName.text!, partyHolder: PartyHolder.text!, partyImg: photoImageView)
        
        ThrowNewParyTapped()
    }
    
    func ThrowNewParyTapped()
    {
        let name: String=PartyName.text!
        let holder: String=PartyHolder.text!
        let place: String=PartyPlace.text!
        let time: String=PartyTime.text!
        let size: String=PartySize.text!
        let picture: String=PartyName.text!+".jpg"
        
        let upLoadMap=["name":name,"holder":holder,"place":place,"ptime":time,
            "size":size,"picture":picture]
       
        var throwParty=NetworkClass().UploadRequest(url: throwPartyUrl, uploadMap: upLoadMap,callback: {(response)->Void in
        
            
        let title = "Throw Party"
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
