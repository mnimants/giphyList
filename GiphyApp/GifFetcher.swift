//
//  GifLoader.swift
//  GiphyApp
//
//  Created by Marcis Nimants on 17/03/2019.
//  Copyright © 2019 Marcis Nimants. All rights reserved.
//

import FLAnimatedImage
import AlamofireImage
import Alamofire
import RxSwift

let cache = NSCache<AnyObject, AnyObject>()

class GifFetcher {
    func loadGif(from url: URL) -> Single<FLAnimatedImage> {
        return Single<FLAnimatedImage>.create { single in
            if let gifFromCache = cache.object(forKey: url.absoluteString as AnyObject) as? FLAnimatedImage {
                single(.success(gifFromCache))
                
                return Disposables.create()
            }
            
            let request = Alamofire.request(url)

            request.responseData { response in
                if let imageData = response.result.value, let animatedImage = FLAnimatedImage(animatedGIFData: imageData) {
                    cache.setObject(animatedImage, forKey: url.absoluteString as AnyObject)
                    single(.success(animatedImage))
                } else {
                    single(.error(NSError()))
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
        
    }
}
