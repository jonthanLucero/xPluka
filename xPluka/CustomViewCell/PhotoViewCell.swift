//
//  PhotoViewCell.swift
//  xPluka
//
//  Created by Peter Arcentales on 12/13/18.
//  Copyright © 2018 Inalambrilk. All rights reserved.
//

import UIKit

class PhotoViewCell: UICollectionViewCell {
    static let identifier = "PhotoViewCell"
    
    //It declares the outlet controls used in the viewcell
    var imageUrl: String = ""
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
}
