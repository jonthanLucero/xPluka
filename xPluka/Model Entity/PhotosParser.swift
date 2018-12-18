//
//  PhotosParser.swift
//  xPluka
//
//  Created by Peter Arcentales on 12/13/18.
//  Copyright © 2018 Inalambrilk. All rights reserved.
//

import Foundation


//It define the structure of the photo parser
struct PhotosParser: Codable {
    let photos: Photos
}

struct Photos: Codable {
    let pages: Int
    let photo: [PhotoParser]
}

struct PhotoParser: Codable {
    
    let url: String?
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case url = "url_n"
        case title
    }
}
