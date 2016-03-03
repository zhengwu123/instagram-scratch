//
//  HomeViewController.swift
//  CourseRater
//
//  Created by New on 2/27/16.
//  Copyright © 2016 CodeMonkey. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var refresher: UIRefreshControl!
    
    @IBAction func onLogOff(sender: AnyObject) {
        print("logout")
        PFUser.logOut()

    }
    
    
    @IBOutlet var tableview: UITableView!
    
    var activityIndicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
        refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableview.addSubview(refresher)
    }
    
    func refresh(){
    
    
    }
    var captions = [String]()
    var usernames = [String]()
    var imagefiles = [PFFile]()
    override func viewDidAppear(animated: Bool) {
        var query = PFQuery(className: "Post")
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let objects = objects {
                
                for object in objects {
                    
                    self.captions.append(object["message"] as! String)
                    
                    self.imagefiles.append(object["imageFile"] as! PFFile)
                    
                    self.usernames.append(object["username"] as! String)
                    
                    self.tableview.reloadData()
                    
                }
                
            }
            
            
        })
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCellWithIdentifier("cell")  as! photoCell
        
        imagefiles[indexPath.row].getDataInBackgroundWithBlock { (data, error) -> Void in
            
            if let downloadedImage = UIImage(data: data!) {
                
                cell.cellImage.image = downloadedImage
                
            }
            
        }
   cell.captionLabel.text = captions[indexPath.row]
        cell.usernamelabel.text = usernames[indexPath.row]
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    

}
