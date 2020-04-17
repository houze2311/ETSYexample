//
//  SearchModelInput.swift
//  EtsyExample
//
//  Created by Dmitriy Demchenko on 1/3/17.
//  Copyright © 2017 Dmitriy Demchenko. All rights reserved.
//

typealias DisplayableSearchData = (category: String, keywords: String)

enum SearchEvent: Event {
  case searchDataPrepared(DisplayableSearchData)
}

protocol SearchModelInput {
  func loadCategories()
  func numberOfCategories() -> Int
  func category(at index: Int) -> SearchModel.DisplayableCategory?
  func selectCategory(at index: Int)
  func enteredText(_ text: String?)
  func searchItems()
}

protocol SearchModelOutput: class {
  func didStartActivity()
  func didFinishActivity(hasNewData: Bool)
  func didFinishActivity(error: Error)
  
  func handleValidationError(_ validationError: String)
}

final class SearchModel: EventNode {
  
  enum ParameterDataType {
    case category, keywords
    
    static func all() -> [ParameterDataType] {
      return [.category, .keywords]
    }
    
  }
  
  weak var output: SearchModelOutput!
  
  struct DisplayableCategory {
    let longName: String
  }
  
  struct SearchData {
    var category = ""
    var keywords = ""
  }
  
  fileprivate var searchData = SearchData()
  fileprivate var categories = [Category]()
  fileprivate var isLoadingData = false
  
}

// MARK: Search parameters data manipulations and validation

fileprivate extension SearchModel {
  
  func validate() -> (Bool, [String]?) {
    var isValid = true
    var errorMessages: [String] = []
    for type in ParameterDataType.all() {
      let value = self.value(for: type)
      let validationResult: (isValid: Bool, validationError: String?) = validate(value, type: type)
      if !validationResult.isValid {
        isValid = false
        errorMessages.append(validationResult.validationError!)
      }
    }
    return (isValid, isValid ? nil : errorMessages)
  }
  
  func value(for type: ParameterDataType) -> String {
    switch type {
    case .category:
      return searchData.category
    case .keywords:
      return searchData.keywords
    }
  }
  
  func updateValue(_ value: String, type: ParameterDataType) {
    switch type {
    case .category:
      searchData.category = value
    case .keywords:
      searchData.keywords = value
    }
  }
  
  func validate(_ value: String, type: ParameterDataType) -> (Bool, String?) {
    var validator: Validator
    switch type {
    case .category:
      validator = Validator(rules: [NameRule(errorMessage: L10n.searchCategoryNameValidationError)])
    case .keywords:
      validator = Validator(rules: [NameRule(errorMessage: L10n.searchKeywordsValidationError)])
    }
    let isValid = validator.validate(value)
    return (isValid, isValid ? nil : validator.errorMessage)
  }
  
}

extension SearchModel: EtsyRequestInjectable, SearchModelInput, SearchViewControllerOutput {
  
  func loadCategories() {
    if !isLoadingData {
      isLoadingData = true
      output.didStartActivity()
      
      let completion: ([Category]?, Error?) -> Void = { [weak self] categories, error in
        guard let strongSelf = self else { return }
        
        guard let categories = categories else {
          dump(error)
          strongSelf.output.didFinishActivity(error: error!)
          return
        }
        
        strongSelf.categories = categories
        strongSelf.output.didFinishActivity(hasNewData: true)
        
        strongSelf.isLoadingData = false
      }
      
      let _ = etsyRequestDecorator.loadCategories(completion)
    } else {
      output.didFinishActivity(hasNewData: false)
    }
  }

  func numberOfCategories() -> Int {
    return categories.count
  }

  func category(at index: Int) -> SearchModel.DisplayableCategory? {
    return displayableCategory(from: categories[index])
  }
  
  func selectCategory(at index: Int) {
    let category = categories[index]
    updateValue(category.longName, type: .category)
  }
  
  func enteredText(_ text: String?) {
    guard let text = text else { return }
    updateValue(text, type: .keywords)
  }
  
  func searchItems() {
    let (isValid, errors) = validate()
    if isValid {
      let event = SearchEvent.searchDataPrepared((
        category: searchData.category,
        keywords: searchData.keywords
      ))
      sendUpstream(event: event, from: self)
    } else if let error = errors?.first {
      output.handleValidationError(error)
    }
  }

}

// MARK: Convertation to displayable structs

fileprivate extension SearchModel {
  
  func displayableCategory(from category: Category) -> DisplayableCategory {
    return DisplayableCategory(longName: category.longName)
  }
  
}
