//
//  TouristicPlace.swift
//  xPluka
//
//  Created by Peter Arcentales on 12/5/18.
//  Copyright © 2018 Inalambrilk. All rights reserved.
//

import Foundation
import CoreData

@objc(TouristicPlace)
public class TouristicPlace: NSManagedObject
{
    static let name = "TouristicPlace"
    
    //It loads the structure of the TouristicPlace Entity to work with
    convenience init(name: String, description: String, type: String, latitude: String, longitude: String, qualification: String, commentary: String, context: NSManagedObjectContext ) {
        if let ent = NSEntityDescription.entity(forEntityName: TouristicPlace.name, in: context)
        {
            self.init(entity: ent, insertInto: context)
            self.tpName = name
            self.tpDescription = description
            self.tpType = type
            self.tpLatitude = latitude
            self.tpLongitude = longitude
            self.tpQualification = qualification
            self.tpCommentary = commentary
        }
        else
        {
            fatalError("Unable to find Entity name!")
        }
    }
}
