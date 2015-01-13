//
//  Alerte.swift
//  MarioGame
//
//  Created by MacBook Pro de Juju on 13/01/2015.
//  Copyright (c) 2015 MacBook Pro de Juju. All rights reserved.
//

import Foundation

class Alerte{
    init(message : String){
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Sign Up Failed!"
        alertView.message = message
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
}