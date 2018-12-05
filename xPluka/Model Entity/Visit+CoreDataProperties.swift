//
//  Visit+CoreDataProperties.swift
//  xPluka
//
//  Created by Peter Arcentales on 12/5/18.
//  Copyright © 2018 Inalambrilk. All rights reserved.
//

import Foundation
import CoreData

extension Visit
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Visit>
    {
        return NSFetchRequest<Visit>(entityName: "Visit")
    }
    
    //It declares the entity Visit properties
    @NSManaged public var vPlannificationDate : String?
    @NSManaged public var vBeginHour: String?
    @NSManaged public var vEndHour: String?
    @NSManaged public var vCommentary: String?
    @NSManaged public var vtouristicPlace: TouristicPlace?
}
