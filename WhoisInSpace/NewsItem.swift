//
//  NewsItem.swift
//  WhoisInSpace
//
//  Created by David on 1/16/15.
//  Copyright (c) 2015 David Fry. All rights reserved.
//

import Foundation

class NewsItem
{
    var title: String
    var link: String
    var description:String
    
    init(title: String, link: String, description:String)
    {
        self.title = title
        self.link = link
        self.description = description
    }
    
    
}