//
//  Classement.swift
//  MarioGame
//
//  Created by MacBook Pro de Juju on 04/01/2015.
//  Copyright (c) 2015 MacBook Pro de Juju. All rights reserved.
//

import SpriteKit

class Classement2 : SKScene{
    
    var classement: [Score] = [Score]()
    
    override func didMoveToView(view: SKView) {
        var username : String = "couuo"//affiche (verif existe)
        
        
        var s : SKLabelNode = SKLabelNode(text: "Marker Felt");
        s.text = " "
        s.fontSize = 40;
        //var g : CGFloat =  CGFloat(Int i)
        s.position = CGPointMake(self.size.width / 2.0,  20);
        self.addChild(s);
        
        var post:String = "nom=DOMPE"
        NSLog(post)
        
        var add = AddresseConnexion().address
        
        var url:NSURL = NSURL(string: add + "record.php")!
        var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        
        var postLength:String = String( postData.length )
        
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        var reponseError: NSError?
        var response: NSURLResponse?
        
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
        //var urlData: NSData? =  NSData(contentsOfURL: NSURL(string: url))
        
        
        if ( urlData != nil ) {
            NSLog("Response code: poriuyt" );
            
            let res = response as NSHTTPURLResponse!;
            
            NSLog("Response code: %ld", res.statusCode);
            
            if (res.statusCode >= 200 && res.statusCode < 300)
                
            {
                
                var error: NSError?
                
                let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as NSDictionary
                
                
                let success:Int = jsonData.valueForKey("success") as Int
                
                //[jsonData[@"success"] integerValue];
                
                NSLog("Success: %ld", success);
                
                
                if(success == 1)
                {
                    NSLog("Login SUCCESS");
                    
                    var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    
                    var nom: AnyObject!
                    var record: AnyObject!
                    //var EtuId: AnyObject!
                    var score1 : Score;
                    
                    var nb: AnyObject! = jsonData["nb"]
                    
                    var nbint = nb.description.toInt()
                    
                    NSLog("e %n",nbint!)
                    
                    for i in 0...nbint!-1{
                        
                        nom = jsonData["classement"]![i]["nom"]
                        record = jsonData["classement"]![i]["record"]
                        // EtuId = jsonData["etu"]![i]["idEtu"]
                        
                        //var ide = EtuId.description.toInt()
                        
                        
                        score1 = Score( p: nom.description , s: record.description)
                        
                        classement.append(score1)
                        NSLog(classement[i].pseudo)
                        NSLog(classement[i].score)
                        
                        
                    }
                    for j in 0...nbint!-1{
                        var s : SKLabelNode = SKLabelNode(text: "Marker Felt");
                        var h = (j + 1)
                        s.text = String(h) + "." + classement[j].pseudo + " —› " + classement[j].score
                        s.fontSize = 20;
                        //var g : CGFloat =  CGFloat(Int i) self.size.height
                        
                        s.position = CGPointMake(self.size.width / 2.0,  ( self.size.height -  self.size.height / 8  - CGFloat(20 * j )));
                        self.addChild(s) ;
                        
                    }
                    
                    
                    
                    
                    //self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    var error_msg:NSString
                    
                    if jsonData["error_message"] as? NSString != nil {
                        error_msg = jsonData["error_message"] as NSString
                    } else {
                        error_msg = "Unknown Error"
                    }
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign in Failed!"
                    alertView.message = error_msg
                    //alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                    
                }
                
            } else {
                
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failed"
                //alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
            
            
        }
        
        
      
    }
    
}





