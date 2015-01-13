//
//  SignupVC.swift
//  SwiftLoginScreen
//
//  Created by Juliette Dompe on 31/07/14.
//  Copyright (c) 2014 Juliette DOMPE. All rights reserved.
//

import UIKit


// classe permettant de s'inscrire
class SignupVC: UIViewController {
    
    //attributs
    @IBOutlet var txtUsername : UITextField!
    @IBOutlet var txtPassword : UITextField!
    @IBOutlet var txtConfirmPassword : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    
    @IBAction func gotoLogin(sender : UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func signupTapped(sender : UIButton) {
        var username = txtUsername.text
        var password = txtPassword.text
        var confirm_password = txtConfirmPassword.text
        
        
        // si les champs sont vides
        if ( username == "" || password == ""  ) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Please enter Username and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
        
        // si mdp et mdp confirm n'est pas egal
        } else if ( !password.isEqual(confirm_password) ) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Passwords doesn't Match"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
        // si les champs sont remplis et les mots de passe identiques
        } else {
            
            var post:NSString = "username=\(username)&password=\(password)&c_password=\(confirm_password)"
            NSLog("PostData: %@",post);
            
            var add = AddresseConnexion().address
            
            var url:NSURL = NSURL(string: add + "jsonsignup.php")!

            
           // var url:NSURL = NSURL(string: "http://192.168.1.99:8888/Test/jsonsignup.php")!
            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            var postLength:NSString = String( postData.length )
            
            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            
            var reponseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
            
            if ( urlData != nil ) {
                let res = response as NSHTTPURLResponse!;
                
                NSLog("Response code: %ld", res.statusCode);
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    
                    NSLog("Response ==> %@", responseData);
                    
                    var error: NSError?
                    
                    let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as NSDictionary
                    
                    
                    let success:Int = jsonData.valueForKey("success") as Int
                    
                    NSLog("Success: %ld", success);
                    
                    //si la requete est excausée
                    if(success == 1)
                    {
                        NSLog("Sign Up SUCCESS");
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        var error_msg:String
                        
                        if jsonData["error_message"]  != nil {
                            error_msg = jsonData["error_message"] as String
                        } else {
                            error_msg = "Unknown Error"
                        }
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign Up Failed!"
                        alertView.message = error_msg
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        
                    }
                    
                } else {
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign Up Failed!"
                    alertView.message = "Connection Failed"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            }  else {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failure"
                if let error = reponseError {
                    alertView.message = (error.localizedDescription)
                }
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
        }
        
    }
    
    //delegate method
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
