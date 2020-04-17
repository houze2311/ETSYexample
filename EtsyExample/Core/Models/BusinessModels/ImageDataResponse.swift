//
//  ImageDataResponse.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/6/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

import Foundation
import ObjectMapper

struct ImageDataResponse {
  var imageDataValue: [ImageData]?
  var imageData: ImageData? { return imageDataValue?.first }
}

extension ImageDataResponse: Mappable {
  
  init?(map: Map) {
    if map.JSON["results"] == nil {
      return nil
    }
  }
  
  mutating func mapping(map: Map) {
    imageDataValue <- map["results"]
  }
  
}

struct ImageData {
  var listingImageId = -1
  var standardResolutionUrl: URL? // 570 x N
  var fullResolutionUrl: URL?
}

extension ImageData: Mappable {
  
  init?(map: Map) {
    if map.JSON["listing_image_id"] == nil {
      return nil
    }
  }
  
  mutating func mapping(map: Map) {
    listingImageId <- map["listing_image_id"]
    standardResolutionUrl <- (map["url_570xN"], URLTransform(shouldEncodeURLString: true))
    fullResolutionUrl <- (map["url_fullxfull"], URLTransform(shouldEncodeURLString: true))
  }
  
}
