//
//  AstronautViewController.swift
//  WhoisInSpace
//
//  Created by David on 1/8/15.
//  Copyright (c) 2015 David Fry. All rights reserved.
//

import UIKit

class AstronautViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    @IBOutlet weak var astronautTableView: UITableView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.astronautTableView.dataSource = self
        self.astronautTableView.delegate = self
        
        // Changes the scroll indicator color to white
        self.astronautTableView.indicatorStyle = UIScrollViewIndicatorStyle.White
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return WhoIsInSpaceAPI.sharedInstance.astroList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = self.astronautTableView.dequeueReusableCellWithIdentifier("ASTRONAUT_CELL", forIndexPath: indexPath) as AstronautTableViewCell
        var astronaut = WhoIsInSpaceAPI.sharedInstance.astroList[indexPath.row]
        cell.profilePhotoImageView.image = astronaut.image
        cell.nameLabel.text = astronaut.name
        cell.craftLabel.text = astronaut.craft
        cell.personalDataLabel.text = astronaut.astronautInfoDict[0]["personalData"] as? String
        cell.personalDataLabel.numberOfLines = 0
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "toAstronautDetailSegue"
        {
            if let indexPath = self.astronautTableView.indexPathForSelectedRow()?.row
            {
                let destVC = segue.destinationViewController as AatronautDetailViewController
                destVC.currentAstronaut = WhoIsInSpaceAPI.sharedInstance.astroList[indexPath]
            }
        }
    }


    



}
