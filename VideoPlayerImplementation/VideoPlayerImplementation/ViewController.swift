//
//  ViewController.swift
//  VideoPlayerImplementation
//
//  Created by Jesus Manuel Prieto Gonzalo on 21/4/17.
//  Copyright © 2017 Jesus Manuel Prieto Gonzalo. All rights reserved.
//

import UIKit
import VideoPlayerFramework
import CoreMedia

class ViewController: UIViewController {
    
    @IBOutlet var playerView: UIView!
    
    var videoPlayer: VideoPlayer?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let videoPath = Bundle.main.path(forResource: "monos", ofType: "mp4")
        if let vPath = videoPath {
            let videoUrl = URL.init(fileURLWithPath: vPath)
            self.videoPlayer = VideoPlayer(view: self.playerView, videoUrl: videoUrl)
        }
    }
}

