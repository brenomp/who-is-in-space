//
//  AstronautList.swift
//  WhoisInSpace
//
//  Created by David on 12/30/14.
//  Copyright (c) 2014 David Fry. All rights reserved.
//

import Foundation

class AstronautList
{
    var listOfAstronautsInSpace: [Astronaut]?
    var peopleInSpaceDict: NSDictionary
    
    init(peopleInSpaceDict: NSDictionary)
    {
        self.peopleInSpaceDict = peopleInSpaceDict as NSDictionary
        self.listOfAstronautsInSpace = self.createListOfAstronauts()
    }
    
    func createListOfAstronauts() -> [Astronaut]
    {
        let peopleArray = self.peopleInSpaceDict["people"] as NSArray
        var astronautList: [Astronaut] = []
        
        for person in peopleArray
        {
            //var newAstronaut: Astronaut = Astronaut(name: person["name"]! as String, craft: person["craft"]! as String)
            //astronautList.append(newAstronaut)
        }
        
        return astronautList
    }
}