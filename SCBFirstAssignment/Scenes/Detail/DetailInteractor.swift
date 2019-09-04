//
//  DetailInteractor.swift
//  SCBFirstAssignment
//
//  Created by Thapakorn Tuwaemuesa on 2/9/2562 BE.
//  Copyright (c) 2562 SCB. All rights reserved.
//

import UIKit

protocol DetailInteractorInterface {
  func getDetail(request: Detail.MobileDetail.Request)
  func getImages(request: Detail.DetailImage.Request)
  var mobile: Mobile { get set }
}

class DetailInteractor: DetailInteractorInterface {
  var presenter: DetailPresenterInterface!
  var worker: MobilesWorker?
  var mobile: Mobile = Mobile()
  var images: ImageResponse = ImageResponse()
  
  // MARK: - Business logic
  
  func getDetail(request: Detail.MobileDetail.Request) {
    if let index = ContentManager.shared.allMobiles.firstIndex(where: { $0.mobile.id == request.id }) {
      mobile = ContentManager.shared.allMobiles[index]
    }
    
    let response = Detail.MobileDetail.Response(detailedMobile: mobile)
    presenter.presentDetail(response: response)
  }
  
  func getImages(request: Detail.DetailImage.Request) {
    worker?.fetchImages(id: request.id, { [weak self] response in
      
      switch response {
      case .success(let result):

        let content : Content<ImageResponse> = .success(data: result)
        let response = Detail.DetailImage.Response(content: content)
        self?.presenter.presentImage(response: response)
      case .failure(let error):
        let content : Content<ImageResponse> = .error(error.localizedDescription)
        let response = Detail.DetailImage.Response(content: content)
        self?.presenter.presentImage(response: response)
      }
    })
  }
}
