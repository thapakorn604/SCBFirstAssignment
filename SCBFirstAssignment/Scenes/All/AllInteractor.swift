//
//  AllInteractor.swift
//  SCBFirstAssignment
//
//  Created by Thapakorn Tuwaemuesa on 1/9/2562 BE.
//  Copyright (c) 2562 SCB. All rights reserved.
//

import UIKit

protocol AllInteractorInterface {
  func loadContent(request: All.FetchMobiles.Request)
  func sortContent(request: All.SortMobiles.Request)
  func updateFavourite(request: All.UpdateFavourite.Request)
  var mobiles: [Mobile] { get set }
}

class AllInteractor: AllInteractorInterface {
  
  var mobiles: [Mobile] = []
  var presenter: AllPresenterInterface!
  var worker: MobilesWorker?
  
  func loadContent(request: All.FetchMobiles.Request) {
    
    worker?.fetchMobiles { [weak self] response in
      
      switch response {
      case .success(let result):
        self?.mobiles = result
        let content: Content<[Mobile]> = .success(data: result)
        let response = All.FetchMobiles.Response(content: content)
        self?.presenter.presentMobiles(response: response)
      case .failure(let error):
        let content: Content<[Mobile]> = .error(error.localizedDescription)
        let response = All.FetchMobiles.Response(content: content)
        self?.presenter.presentMobiles(response: response)
      }
    }
  }
  
  func sortContent(request: All.SortMobiles.Request) {
    
    switch request.sortingType {
    case .priceDescending: sortByPriceDescending()
    case .priceAscending: sortByPriceAscending()
    case .rating: sortByRating()
    }
    let content : Content<[Mobile]> = .success(data: self.mobiles)
    let response = All.FetchMobiles.Response(content: content)
    self.presenter.presentMobiles(response: response)
  }
  
  func sortByPriceAscending() {
    ContentManager.shared.allMobiles = ContentManager.shared.allMobiles.sorted { $0.mobile.price < $1.mobile.price }
    self.mobiles = ContentManager.shared.allMobiles
  }
  
  func sortByPriceDescending() {
    ContentManager.shared.allMobiles = ContentManager.shared.allMobiles.sorted { $0.mobile.price > $1.mobile.price }
    self.mobiles = ContentManager.shared.allMobiles
  }
  
  func sortByRating() {
    ContentManager.shared.allMobiles = ContentManager.shared.allMobiles.sorted { $0.mobile.rating > $1.mobile.rating }
    self.mobiles = ContentManager.shared.allMobiles
  }
  
  func updateFavourite(request: All.UpdateFavourite.Request) {
    
    guard let index = ContentManager.shared.allMobiles.firstIndex(where: { $0.mobile.id == request.id }) else { return }
    var element = ContentManager.shared.allMobiles[index]
    
    if !element.isFav {
      element.isFav = true
      ContentManager.shared.favMobiles.append(element)
      ContentManager.shared.allMobiles[index].isFav = true
    } else if let favIndex = ContentManager.shared.favMobiles.firstIndex(where: { $0.mobile.id == request.id }) {
      element.isFav = false
      ContentManager.shared.favMobiles.remove(at: favIndex)
      ContentManager.shared.allMobiles[index].isFav = false
    }
    
    self.mobiles = ContentManager.shared.allMobiles
    
    let content : Content<[Mobile]> = .success(data: self.mobiles)
    let response = All.FetchMobiles.Response(content: content)
    self.presenter.presentMobiles(response: response)
  }
}
