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
    @NSManaged public var vId:String
    @NSManaged public var vPlannificationDateBegin : Date?
    @NSManaged public var vPlannificationDateEnd : Date?
    @NSManaged public var vCommentary: String?
    @NSManaged public var touristiPlaceVisit: TouristicPlace?
    @NSManaged public var vCreationDate: Date?
    @NSManaged public var vModificationDate: Date?
}
