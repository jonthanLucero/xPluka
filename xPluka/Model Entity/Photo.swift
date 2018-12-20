//
//  Photo.swift
//  xPluka
//
//  Created by Peter Arcentales on 12/5/18.
//  Copyright © 2018 Inalambrilk. All rights reserved.
//

import Foundation
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {
    static let name = "Photo"
    
    convenience init(touristicPlace: TouristicPlace, title: String, imageUrl: String, context: NSManagedObjectContext ) {
        if let ent = NSEntityDescription.entity(forEntityName: Photo.name, in: context)
        {
            self.init(entity: ent, insertInto: context)
            self.title = title
            self.image = nil
            self.urlImage = imageUrl
            self.touristicPlacePhoto = touristicPlace
        }
        else{
            fatalError("Unable to find Entity Name!")
        }
    }
}
