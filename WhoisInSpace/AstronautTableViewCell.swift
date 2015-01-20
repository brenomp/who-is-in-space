//
//  AstronautTableViewCell.swift
//  WhoisInSpace
//
//  Created by David on 1/13/15.
//  Copyright (c) 2015 David Fry. All rights reserved.
//

import UIKit

class AstronautTableViewCell: UITableViewCell
{

    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var craftLabel: UILabel!
    @IBOutlet weak var personalDataLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
