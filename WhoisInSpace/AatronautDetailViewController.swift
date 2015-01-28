//
//  AatronautDetailViewController.swift
//  WhoisInSpace
//
//  Created by David on 1/8/15.
//  Copyright (c) 2015 David Fry. All rights reserved.
//

import UIKit

class AatronautDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var astronautNameLabel: UILabel!
    @IBOutlet weak var astronautProfileImage: UIImageView!
    @IBOutlet weak var astronautDetailTableView: UITableView!
    
    var currentAstronaut: Astronaut?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.astronautDetailTableView.dataSource = self
        self.astronautDetailTableView.delegate = self
        
        self.astronautNameLabel.text = self.currentAstronaut?.name
        self.astronautProfileImage.image = self.currentAstronaut?.image
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return self.currentAstronaut!.astronautInfoDict.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        switch section
        {
        case 0:
            return "Personal Data"
        case 1:
            return "Education"
        case 2:
            return "Awards"
        case 3:
            return "Experience"
        default:
            return "Default Section"
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = self.astronautDetailTableView.dequeueReusableCellWithIdentifier("ASTRONUAT_DETAIL_CELL", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        switch indexPath.section
        {
        case 0:
            cell.textLabel?.text = self.currentAstronaut?.astronautInfoDict[indexPath.section]["personalData"] as? String
            cell.textLabel?.numberOfLines = 0
        case 1:
            cell.textLabel?.text = self.currentAstronaut?.astronautInfoDict[indexPath.section]["education"] as? String
            cell.textLabel?.numberOfLines = 0
        case 2:
            cell.textLabel?.text = self.currentAstronaut?.astronautInfoDict[indexPath.section]["awards"] as? String
            cell.textLabel?.numberOfLines = 0
        case 3:
            cell.textLabel?.text = self.currentAstronaut?.astronautInfoDict[indexPath.section]["experience"] as? String
            cell.textLabel?.numberOfLines = 0
        default:
            println("Something went worng")
            
        }
        
        return cell
    }


}
