//
//  Client+Extension.swift
//  xPluka
//
//  Created by Peter Arcentales on 12/13/18.
//  Copyright © 2018 Inalambrilk. All rights reserved.
//

import Foundation

extension Client {
    
    //It Contains the struct to use in the flickr api
    struct Flickr {
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest"
        
        static let SearchBoxHalfWidth = 0.2
        static let SearchBoxHalfHeight = 0.2
        static let SearchLatRange = (-90.0, 90.0)
        static let SearchLongRange = (-180.0, 180.0)
    }
    
    //It contains the flickr parameters keys to work with
    struct FlickrParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let GalleryID = "gallery_id"
        static let Extras = "extras"
        static let Format = "format"
        static let NOJSONCallBack = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let BoundingBox = "bbox"
        static let PhotosPerPage = "per_page"
        static let Accuracy = "accuracy"
        static let Page = "page"
    }
    
    //It contains the flickr parameter values to work with
    struct FlickrParameterValues
    {
        static let SearchMethod = "flickr.photos.search"
        static let APIKey = "6b52cfdbcf767c6bf3b31a1eb13c6700"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1" /* 1 means "yes" */
        static let MediumURL = "url_n"
        static let UseSafeSearch = "1" /* 1 means safe content */
        static let PhotosPerPage = 30
        static let AccuracyCityLevel = "11"
        static let AccuracyStreetLevel = "16"
    }
}
