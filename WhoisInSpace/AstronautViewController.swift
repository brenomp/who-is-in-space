//
//  AstronautViewController.swift
//  WhoisInSpace
//
//  Created by David on 1/8/15.
//  Copyright (c) 2015 David Fry. All rights reserved.
//

import UIKit

class AstronautViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        println(WhoIsInSpaceAPI.sharedInstance.astroList)
    }


    



}
