//
//  PlayScene.swift
//  Game
//
//  Created by MacBook Pro de Juju on 29/12/2014.
//  Copyright (c) 2014 MacBook Pro de Juju. All rights reserved.
//


import SpriteKit


enum MoveDirection: Int {
    case None, Forward, Backward
}

class PlayScene: SKScene, SKPhysicsContactDelegate {
    
    
    var bool : Bool = false;
    var Counter = 0
    var Timer : NSTimer = NSTimer()
    var Temps : NSTimer = NSTimer()
    var TimeLabel : SKLabelNode = SKLabelNode(text: "Marker Felt");
    var speede : CGFloat = 0;
    
    
    let map = JSTileMap(named: "level.tmx");
    var hero = SKSpriteNode(imageNamed: "marioSmall_standing");
    var obstacles = SKNode();
    // var swipeJumpGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer();
    var move: MoveDirection = .None;
    var isJumping: Bool = false;
    
    /*required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder);
    self.initialisation();
    }*/
    
    init(size: CGSize, speed : CGFloat) {
        super.init(size: size);
        self.speede = speed
        self.initialisation();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    func initialisation () -> () {
        
        //self.backgroundColor = UIColor(hex: 0x80D9DF)
        self.backgroundColor = UIColor(red: 104.0 / 255.0, green: 136.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0);
        self.addChild(self.map);
        
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: self.frame.origin.x , y: self.frame.origin.y - 30, width: self.frame.size.width, height: self.frame.size.height));
        self.physicsBody!.friction = 0.0;
        self.physicsWorld.contactDelegate = self;
        let collisionsGroup: TMXObjectGroup = self.map.groupNamed("Collisions");
        for(var i = 0; i < collisionsGroup.objects.count; i++) {
            let collisionObject = collisionsGroup.objects.objectAtIndex(i) as NSDictionary;
            
            println(collisionObject);
            
            let width = collisionObject.objectForKey("width") as String;
            let height = collisionObject.objectForKey("height") as String;
            let someObstacleSize = CGSize(width: width.toInt()!, height: height.toInt()!);
            
            let someObstacle = SKSpriteNode(color: UIColor.clearColor(), size: someObstacleSize);
            
            let y = collisionObject.objectForKey("y") as Int;
            let x = collisionObject.objectForKey("x") as Int;
            
            someObstacle.position = CGPoint(x: x + Int(collisionsGroup.positionOffset.x) + width.toInt()!/2, y: y + Int(collisionsGroup.positionOffset.y) + height.toInt()!/2);
            someObstacle.physicsBody = SKPhysicsBody(rectangleOfSize: someObstacleSize);
            someObstacle.physicsBody!.affectedByGravity = false;
            someObstacle.physicsBody!.collisionBitMask = 0;
            someObstacle.physicsBody!.friction = 0.2;
            someObstacle.physicsBody!.restitution = 0.0;
            
            self.obstacles.addChild(someObstacle)
        }
        self.addChild(self.obstacles);
        
        // Setup Mario
        let startLocation = CGPoint(x: 125 , y: 80);
        self.hero.position = startLocation;
        self.hero.size = CGSize(width: 32, height: 32);
        self.hero.physicsBody = SKPhysicsBody(circleOfRadius: self.hero.frame.size.width/2);
        self.hero.physicsBody!.friction = 0.2;
        self.hero.physicsBody!.restitution = 0;
        self.hero.physicsBody!.linearDamping = 0.0;
        self.hero.physicsBody!.allowsRotation = false;
        self.hero.physicsBody!.dynamic = true;
        
        self.addChild(self.hero);
        self.time()
        
    }
    
    
    /*  modifffff
    *override func didMoveToView(view: SKView) {
    super.didMoveToView(view);
    
    self.swipeJumpGesture.addTarget(self, action: Selector("handleJumpSwipe:"));
    self.swipeJumpGesture.direction = .Up;
    self.swipeJumpGesture.numberOfTouchesRequired = 1;
    self.view!.addGestureRecognizer(self.swipeJumpGesture);
    }
    
    func handleJumpSwipe(sender: UIGestureRecognizer) {
    if !self.isJumping {
    self.marioJump();
    self.isJumping = true;
    }
    else if sender.state == UIGestureRecognizerState.Ended {
    self.move = .None;
    self.isJumping = false;
    }
    }
    */
    func marioJump() {
        
        self.hero.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 30), atPoint: CGPoint(x: self.hero.frame.width/2, y: 0));
        
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            
            var touchMe: UITouch = touch as UITouch;
            let location = touch.locationInNode(self);
            
            let screenWidth = self.frame.width;
            if location.x > (screenWidth / 2){
                self.move = .None;
                var marioSmall_Norunning = [SKTexture]();
                marioSmall_Norunning.append( SKTexture(imageNamed: "marioSmall_standing") );
                let runningAction = SKAction.animateWithTextures(marioSmall_Norunning, timePerFrame: 1);
                self.hero.runAction(SKAction.repeatActionForever(runningAction))
                
                
            }
            else {
                //if (self.hero.position.y <= 200){
                if(isJumping){
                    self.isJumping =  false;
                }
                
                
            }
        }
        
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            
            var touchMe: UITouch = touch as UITouch;
            let location = touch.locationInNode(self);
            
            let screenWidth = self.frame.width;
            if location.x > (screenWidth / 2){
                if ( (location.x >= ((self.size.width - self.size.width / 4) - 50 )) && (location.y >= ((3 * self.size.height / 4) - 20))){
                    
                    if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
                        let skView = self.view! as SKView
                        skView.ignoresSiblingOrder = true
                        scene.scaleMode = .AspectFill
                        skView.presentScene(scene)
                    }
                    
                    
                }else{
                    
                    
                    self.move = .Forward;
                    var marioSmall_running = [SKTexture]();
                    for i in 0...2 {
                        marioSmall_running.append( SKTexture(imageNamed: "marioSmall_running\(i)") );
                    }
                    let runningAction = SKAction.animateWithTextures(marioSmall_running, timePerFrame: 0.1);
                    self.hero.runAction(SKAction.repeatActionForever(runningAction))
                }
                
            }else {
                //if(!isJumping){
                if((hero.position.y <= (3 * self.frame.height / 4)) && !isJumping){
                    self.isJumping = true;
                    self.marioJump();
                    NSLog( hero.position.x.description )
                }
            }
        }
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody  = contact.bodyA;
        let secondBody: SKPhysicsBody = contact.bodyB;
        
        if(self.isJumping == true && (firstBody.node == self.hero || secondBody.node == self.hero)) {
            self.isJumping = false;
            self.move = .None;
        }
    }
    
    func win(){
        
        //self.move = .None
        var gameText = "Bravo!";
        var endGameLabel : SKLabelNode  = SKLabelNode(text: "Marker Felt");
        endGameLabel.text = gameText;
        endGameLabel.fontSize = 40;
        endGameLabel.position = CGPointMake(self.size.width / 2.0, self.size.height / 1.7);
        self.addChild(endGameLabel);
        
        Timer.invalidate()
        var resTime : SKLabelNode  = SKLabelNode(text: "Marker Felt");
        resTime.text = TimeLabel.text;
        resTime.fontSize = 40;
        resTime.position = CGPointMake(self.size.width / 2.0, self.size.height / 1.5);
        self.addChild(resTime);
        
        Temps =  NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("nouveauLevel"), userInfo: nil, repeats: false)
        
        save()
        //self.nouveauLevel(speede + 4)
        
        
        
    }
    func save(){
        
        var record = self.Counter
        var username = " "
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Please enter Username and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
            
        } else {
            username = prefs.valueForKey("USERNAME") as NSString
            NSLog("yess")
        }
        NSLog(username)
        
        // si c'est vide
        if ( username == "" || record == 0  ) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Please enter Username and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
            
        } else {
            
            var post:NSString = "username=\(username)&record=\(record)"
            
            NSLog("PostData: %@",post);
            
            var add = AddresseConnexion().address
            
            var url:NSURL = NSURL(string: add + "recordUp.php")!
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
                
                if (res.statusCode >= 200 && res.statusCode < 300){
                    var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    
                    NSLog("Response ==> %@", responseData);
                    
                } else {
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign Up Failed!"
                    alertView.message = "Connection Failed"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                    
                }
            }
            
        }
    }
    
        
        
        func nouveauLevel(){
            self.bool = true
            
        }
        
        
        func time(){
            
            TimeLabel = SKLabelNode(text: "Marker Felt");
            
            TimeLabel.text = " " + String(Counter)
            TimeLabel.fontSize = 40;
            TimeLabel.position = CGPointMake(self.size.width - self.size.width / 4 , 3 * self.size.height / 4);
            self.addChild(TimeLabel)
            Timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("UpdateTimer"), userInfo: nil, repeats: true)
            
        }
        
        func UpdateTimer() {
            TimeLabel.hidden = true
            TimeLabel = SKLabelNode(text: "Marker Felt");
            TimeLabel.fontSize = 40;
            TimeLabel.position = CGPointMake(self.size.width - self.size.width / 4 , 3 * self.size.height / 4);
            self.addChild(TimeLabel)
            TimeLabel.text = " " + String(Counter++)
            
        }
        
        func ResetButton(sender: AnyObject) {
            Timer.invalidate()
            Counter = 0
            TimeLabel.text = String(Counter)
        }
        
        
        
        func died() {
            if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
                var skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .AspectFill
                skView.presentScene(scene)
                
                
                
                
            }
            
        }
        
        
        override func update(currentTime: CFTimeInterval) {
            
            
            if(bool == true){
                
                
 
                //nouveau niveau (augmentation de la vitesse)
                var scene = PlayScene(size: self.size, speed : (speede + 1))
                var skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .AspectFill
                skView.presentScene(scene)
                
                
                
        
            }
            
            
            if(hero.position.y <= self.frame.origin.y){
                self.died()
                
            }
            
            if(self.map.position.x == (-1) * 6440 || self.map.position.x == 6440){
                self.win()
                
            }
            if(self.map.position.x == 100.5 ){
                self.win()
                
            }

            
            
            /*  if(isJumping){
            if (self.hero.position.y <= 1000){
            self.isJumping =  false;
            }
            }*/
            
            if self.move == .Forward {
                if(self.hero.position.x >= self.frame.width / 3){
                    speede = self.map.position.x - speede - self.frame.width * (-1.0) > self.map.mapSize.width * self.map.tileSize.width ? 0 : speede;
                    self.obstacles.position.x = self.obstacles.position.x - speede
                    self.map.position.x = self.map.position.x - speede
                }else{
                    hero.position.x = hero.position.x + speede
                }
                
                /*  }else if self.move == .Backward {
                speed = self.map.position.x + speed > 0 ? 0 : speed;
                self.obstacles.position.x = self.obstacles.position.x  + speed
                self.map.position.x = self.map.position.x + speed
                }*/
            }
        }
}

