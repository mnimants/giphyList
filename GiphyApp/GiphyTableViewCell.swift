//
//  GiphyTableViewCell.swift
//  GiphyApp
//
//  Created by Marcis Nimants on 17/03/2019.
//  Copyright © 2019 Marcis Nimants. All rights reserved.
//

import UIKit
import FLAnimatedImage
import Alamofire
import RxSwift

class GiphyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var animatedImageView: FLAnimatedImageView!
    
    @IBOutlet weak var gifTitleLabel: UILabel!

    var gif: Gif?
    
    private var disposable: Disposable?

    func configureCell(with gif: Gif) {
        self.gif = gif
        
        gifTitleLabel.text = gif.name
        
        disposable = GifFetcher().loadGif(from: gif.smallURL).subscribe(onSuccess: { (animatedImage) in
            self.animatedImageView.animatedImage = animatedImage
        }) { (error) in
            print(error)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        animatedImageView.animatedImage = nil
        disposable?.dispose()
    }
}
