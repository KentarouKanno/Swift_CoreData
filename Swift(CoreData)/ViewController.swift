//
//  ViewController.swift
//  Swift(CoreData)
//
//  Created by KentarOu on 2015/08/09.
//  Copyright (c) 2015年 KentarOu. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // NSManagedObject Array
    var myCoreDataObj: [AnyObject] = []
    
    // CustomModel Array
    var myDataModel: [DataModel] = []
    
    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var myTableView: UITableView!
    
    var myContext: NSManagedObjectContext!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        myContext = appDel.managedObjectContext!
        
        readData()
    }

    
    @IBAction func onClickMyButton(sender: UIButton) {
        
        if sender.tag == 1 {
            writeData()
        } else if sender.tag == 2 {
            readData()
        }
    }

    // DB Insert
    func writeData() {
        
        let myEntity: NSEntityDescription! = NSEntityDescription.entityForName("MyCoreDataStore", inManagedObjectContext: myContext)
        
        let newData = MyCoreDataStore(entity: myEntity, insertIntoManagedObjectContext: myContext)
        newData.statement = myTextField.text!
        newData.time = NSDate()
        
        // Migration 追加⑤
        newData.name = "KentarOu"
        
        do {
            try myContext.save()
        } catch _ {
        }
        
        readData()
    }
    
    
    // DB Select
    func readData(){
        
        let myRequest: NSFetchRequest = NSFetchRequest(entityName: "MyCoreDataStore")
        myRequest.returnsObjectsAsFaults = false
        
        myCoreDataObj = try! myContext.executeFetchRequest(myRequest)
        
        
        myDataModel = []
        
        for myData in myCoreDataObj {
        
            let model = DataModel()
            model.statement = myData.statement
            model.time =  myData.time
            
            myDataModel.append(model)
        }
        myTableView.reloadData()
    }
    
    // DB Delete 
    func deleteData(indexPath: NSIndexPath) -> () {
        
        let coreDetaModel: AnyObject = myCoreDataObj[indexPath.row]
        myContext.deleteObject(coreDetaModel as! NSManagedObject)
        do {
            try myContext.save()
        } catch _ {
        }
        
        readData()
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        myTextField.resignFirstResponder()
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        deleteData(indexPath)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view .endEditing(true)
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDataModel.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"MyCell" )
        
        cell.textLabel!.sizeToFit()
        cell.textLabel!.textColor = UIColor.blackColor()
        cell.textLabel!.text = "\(myDataModel[indexPath.row].statement)"
        cell.textLabel!.font = UIFont.systemFontOfSize(20)
        
        cell.detailTextLabel!.text = "\(myDataModel[indexPath.row].time)"
        cell.detailTextLabel!.font = UIFont.systemFontOfSize(12)
        cell.detailTextLabel!.textColor = UIColor.grayColor()
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
