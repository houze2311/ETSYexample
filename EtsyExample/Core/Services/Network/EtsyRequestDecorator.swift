//
//  EtsyRequestDecorator.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/4/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

typealias ItemsCompletion = (_ items: [Item]?, _ count: Int, _ error: Error?) -> Void

final class EtsyRequestDecorator {
  
  func loadCategories(_ completion: @escaping ([Category]?, Error?) -> Void) {
    let url = Constants.API.baseURL
      .appendingPathComponent(Constants.Path.categories)
      .absoluteString
      .removingPercentEncoding!
    
    let parameters: Parameters = ["api_key": Constants.Etsy.apiKey]
    
    let request = AF.request(url, parameters: parameters)
    request.responseObject { (response: DataResponse<CategoriesResponse>) in
      switch response.result {
      case .success:
        let categoryResponse = response.value
        completion(categoryResponse?.categories, nil)
      case .failure(let error):
        completion(nil, error)
      }
    }
  }
  
  func loadItems(with keywords: String, of category: String, offset: Int, completion: @escaping ItemsCompletion) {
    let parameters: Parameters = [
      "api_key": Constants.Etsy.apiKey,
      "category": category,
      "keywords": keywords,
      "limit": Constants.UI.paginationLimit,
      "offset": offset
      ]
    
    let url = Constants.API.baseURL
      .appendingPathComponent(Constants.Path.listings)
      .absoluteString
      .removingPercentEncoding!
    
    let request = AF.request(url, parameters: parameters)
    request.responseObject { (response: DataResponse<ItemsResponse>) in
      switch response.result {
      case .success:
        let listings = response.value
        completion(listings?.items, listings?.count ?? 0, nil)
      case .failure(let error):
        completion(nil, 0, error)
      }
    }
  }
  
  func loadImageData(for listingsId: Int, completion: @escaping (ImageData?, Error?) -> Void) {
    let url = Constants.API.baseURL
      .appendingPathComponent("listings/\(listingsId)/images")
      .absoluteString
      .removingPercentEncoding!
    
    let parameters: Parameters = ["api_key": Constants.Etsy.apiKey]
    
    let request = AF.request(url, parameters: parameters)
    request.responseObject { (response: DataResponse<ImageDataResponse>) in
      switch response.result {
      case .success:
        let imageDataResponse = response.value
        completion(imageDataResponse?.imageData, nil)
      case .failure(let error):
        completion(nil, error)
      }
    }
  }
  
}
