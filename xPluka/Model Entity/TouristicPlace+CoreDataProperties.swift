//
//  TouristicPlace+CoreDataProperties.swift
//  xPluka
//
//  Created by Peter Arcentales on 12/5/18.
//  Copyright © 2018 Inalambrilk. All rights reserved.
//

import Foundation
import CoreData

extension TouristicPlace
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TouristicPlace>
    {
        return NSFetchRequest<TouristicPlace>(entityName: "TouristicPlace")
    }
    
    //It declares the entity TouristicPlace properties
    @NSManaged public var tpName: String?
    @NSManaged public var tpDescription: String?
    @NSManaged public var tpType: String?
    @NSManaged public var tpLatitude: String?
    @NSManaged public var tpLongitude: String?
    @NSManaged public var tpQualification: String?
    @NSManaged public var tpCommentary: String?
}
