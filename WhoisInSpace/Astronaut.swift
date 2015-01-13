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
    
    init(name: String, craft: String, image: UIImage)
    {
        self.name = name
        self.craft = craft
        self.image = image
    }
}