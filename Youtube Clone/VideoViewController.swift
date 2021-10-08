//
//  VideoViewController.swift
//  Youtube Clone
//
//  Created by Alex on 08/10/2021.
//

import UIKit
import AVKit
import AVFoundation

class VideoViewController: UIViewController {

    @IBOutlet weak var videoView: UIView!
    var player: AVPlayer?
    var playerLayer = AVPlayerLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(false)
//        
//        let videoURL = URL(string: "https://wolverine.raywenderlich.com/content/ios/tutorials/video_streaming/foxVillage.mp4") 
//        let player = AVPlayer(url: videoURL!)
//        let avPlayerViewController = AVPlayerViewController()
//        avPlayerViewController.player = player
//        avPlayerViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/3)
//        //self.addChild(avPlayerViewController)
//        self.addChild(avPlayerViewController)
//        self.view.addSubview(avPlayerViewController.view)
//        avPlayerViewController.didMove(toParent: self)
    }
