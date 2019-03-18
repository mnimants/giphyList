//
//  GiphyApi.swift
//  GiphyApp
//
//  Created by Marcis Nimants on 17/03/2019.
//  Copyright © 2019 Marcis Nimants. All rights reserved.
//

import RxSwift
import Alamofire
import SwiftyJSON

class GiphyApi {
    private let apiKey = "jrGXyMFVt4RES4Nch9Fy21Io4hOMda9g"
    
    func getGifs(byKeyword keyword: String) -> Single<[Gif]> {
        return Single<[Gif]>.create { single in
            let urlString = "https://api.giphy.com/v1/gifs/search"
            
            let parameters: [String: Any] = [
                "api_key": self.apiKey,
                "q": keyword,
                "offset": 0,
                "limit": 25
            ]
            
            let request = Alamofire.request(urlString, parameters: parameters)
            
            request.responseJSON { response in
                if let error = response.error {
                    single(.error(error))
                    return
                }
                
                var gifs: [Gif]?
                
                defer {
                    single(.success(gifs ?? []))
                }
                
                guard let results = response.result.value else { return }
                
                let json = JSON(results)
                
                let imageData = json["data"].arrayValue
                
                gifs = imageData.compactMap {
                    let smallUrlString = $0["images"]["fixed_width_small"]["url"].stringValue
                    let largeUrlString = $0["images"]["downsized_medium"]["url"].stringValue
                    let name = $0["title"].stringValue
                    
                    guard let smallUrl = URL(string: smallUrlString) else { return nil }
                    guard let largeUrl = URL(string: largeUrlString) else { return nil }
                    
                    return Gif(smallURL: smallUrl, largeURL: largeUrl, name: name)
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
