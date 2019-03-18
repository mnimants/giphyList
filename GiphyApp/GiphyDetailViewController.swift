//
//  GiphyDetailViewController.swift
//  GiphyApp
//
//  Created by Marcis Nimants on 17/03/2019.
//  Copyright © 2019 Marcis Nimants. All rights reserved.
//

import UIKit
import FLAnimatedImage
import RxSwift

class GiphyDetailViewController: UIViewController {

    @IBOutlet weak var animatedImageView: FLAnimatedImageView!
    
    var gif: Gif!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        title = gif.name
        
        GifFetcher().loadGif(from: gif.largeURL).subscribe(onSuccess: { (animatedImage) in
            self.animatedImageView.animatedImage = animatedImage
        }) { (error) in
            print(error)
        }.disposed(by: disposeBag)
    }
}
