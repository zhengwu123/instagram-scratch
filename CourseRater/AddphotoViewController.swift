//
//  AddphotoViewController.swift
//  CourseRater
//
//  Created by New on 2/27/16.
//  Copyright © 2016 CodeMonkey. All rights reserved.
//

import UIKit
import Parse

class AddphotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var captionText: UITextField!
    @IBOutlet var imagePost: UIImageView!
    var activityIndicator = UIActivityIndicatorView()
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        imagePost.image = image
    }
    
    func go(){
    self.performSegueWithIdentifier("posttotable", sender: self)
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Onalbum(sender: AnyObject) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
    }

    @IBAction func OnCamera(sender: AnyObject) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.Camera
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    @IBAction func onPost(sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.6)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        var post = PFObject(className: "Post")
        
        post["message"] = captionText.text
        
        post["userId"] = PFUser.currentUser()!.objectId!
        post["username"] = PFUser.currentUser()?.username
        
        let imageData = UIImagePNGRepresentation(resize(imagePost.image!, newSize: CGSizeMake(300,300)))
        
        let imageFile = PFFile(name: "image.png", data: imageData!)
        
        post["imageFile"] = imageFile
        
        post.saveInBackgroundWithBlock{(success, error) -> Void in
            
            self.activityIndicator.stopAnimating()
            
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if error == nil {
                
                self.displayAlert("Image Posted!", message: "Your image has been posted successfully")
                
                self.imagePost.image = UIImage(named: "image_file-1.png")
                
                self.captionText.text = ""
             let vc = self.storyboard!.instantiateViewControllerWithIdentifier("tap")
                self.showViewController(vc as UIViewController, sender: vc)
                
            } else {
                
                self.displayAlert("Could not post image", message: "Please try again later")
                
            }
            
        }

    }
    
    
    @IBAction func onTap(sender: AnyObject) {
        self.view.endEditing(true)
    }
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool{
        captionText.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
}
