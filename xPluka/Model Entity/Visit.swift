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
    convenience init(visitId: String, touristicPlace: TouristicPlace, plannificationDateBegin : Date,plannificationDateEnd : Date, commentary: String, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName:Visit.name , in: context)
        {
            self.init(entity: ent, insertInto: context)
            self.vId = visitId
            self.vPlannificationDateBegin = plannificationDateBegin
            self.vPlannificationDateEnd = plannificationDateEnd
            self.vCommentary = commentary
            self.vCreationDate = NSDate() as Date
            self.vModificationDate = NSDate() as Date
            self.touristiPlaceVisit = touristicPlace
        }
        else
        {
            fatalError("Unable to find Entity name!")
        }
    }
}
