//
//  Photo+CoreDataProperties.swift
//  xPluka
//
//  Created by Peter Arcentales on 12/5/18.
//  Copyright © 2018 Inalambrilk. All rights reserved.
//

import Foundation
import CoreData

extension Photo {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }
    
    //It declares the entity Photo properties
    @NSManaged public var image: NSData?
    @NSManaged public var title: String?
    @NSManaged public var urlImage: String?
    @NSManaged public var touristicPlacePhoto: TouristicPlace?
    
}
