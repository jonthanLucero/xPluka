//
//  Visit.swift
//  xPluka
//
//  Created by Peter Arcentales on 12/5/18.
//  Copyright © 2018 Inalambrilk. All rights reserved.
//

import Foundation
import CoreData

@objc(Visit)

public class Visit: NSManagedObject
{
    static let name = "Visit"
    
    //It loads the structure of the Visit Entity to work with
    convenience init(plannificationDate : String, beginHour: String, endHour: String, commentary: String, touristicPlace: TouristicPlace, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName:Visit.name , in: context)
        {
            self.init(entity: ent, insertInto: context)
            self.vPlannificationDate = plannificationDate
            self.vBeginHour = beginHour
            self.vEndHour = endHour
            self.vCommentary = commentary
            self.vtouristicPlace = touristicPlace
        }
        else
        {
            fatalError("Unable to find Entity name!")
        }
    }
}
