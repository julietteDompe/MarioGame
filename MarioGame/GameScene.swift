//
//  GameScene.swift
//  Game
//
//  Created by MacBook Pro de Juju on 29/12/2014.
//  Copyright (c) 2014 MacBook Pro de Juju. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let playButton = SKSpriteNode(imageNamed:"play")
    let playButton2 = SKSpriteNode(imageNamed:"records")
    let recordLab = SKLabelNode(text: "Classement");
    
    override func didMoveToView(view: SKView) {
       
        self.playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(CGRectMake(0,450, 10, 10)))
        self.addChild(self.playButton)
        self.playButton2.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(CGRectMake(0,300, 10, 10)))
        self.addChild(self.playButton2)
        self.recordLab.fontSize = 40;
        self.recordLab.position = CGPointMake(self.size.width / 2.0, ((self.size.height / 3 ) - 20));
        self.addChild(self.recordLab);

        //self.backgroundColor = UIImage(named: "champ.png")// UIColor(hex: 0x80D9FF)
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "yourImage.png"))
        
        self.backgroundColor = UIColor(hex: 0xB03638)

        //self.backgroundColor = UIColor(patternImage: UIImage(named: "champ.png")!)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.playButton {
                self.backgroundColor = UIColor(hex: 0x80D9DF)
                var scene = PlayScene(size: self.size, speed: 4)
                let skView = self.view!   as SKView

                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                skView.presentScene(scene)
              
          
                
                
            }else if self.nodeAtPoint(location) == self.playButton2 {
                self.backgroundColor = UIColor(hex: 990033)
                
                var scene = Classement2()
                let skView = self.view!   as SKView
                
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                skView.presentScene(scene)

            
                //self.presentViewController(classement, animated: true , completion: nil )
            }
            
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}


