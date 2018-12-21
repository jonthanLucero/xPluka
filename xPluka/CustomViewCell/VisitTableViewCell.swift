//
//  VisitCell.swift
//  xPluka
//
//  Created by Peter Arcentales on 12/18/18.
//  Copyright © 2018 Inalambrilk. All rights reserved.
//

import UIKit

class VisitTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "VisitCell"
    
    //It declares the outlet controls used in the viewcell
    @IBOutlet weak var touristicPlaceImageType: UIImageView!
    @IBOutlet weak var touristicPlaceName: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endYear: UILabel!
    @IBOutlet weak var startYear: UILabel!
    @IBOutlet weak var endDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
