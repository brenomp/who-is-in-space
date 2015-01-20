//
//  Astronaut.swift
//  WhoisInSpace
//
//  Created by David on 12/30/14.
//  Copyright (c) 2014 David Fry. All rights reserved.
//

import Foundation
import UIKit

class Astronaut
{
    var name: String
    var craft: String
    var image: UIImage
    var astronautInfoDict: [NSDictionary]
    
    var kPersonalData = "personalData"
    var kEducation = "education"
    var kAwards = "awards"
    var kExperience = "experience"
    
    init(name: String, craft: String, image: UIImage, astronautInfoDict: [NSDictionary])
    {
        self.name = name
        self.craft = craft
        self.image = image
        self.astronautInfoDict = astronautInfoDict
    }
}