//
//  VideoLauncher.swift
//  Youtube Clone
//
//  Created by Alex on 08/10/2021.
//

import UIKit

class VideoLauncher: NSObject {
    
    //var keyWindow: UIWindow?
    
    func showVideoPlayer() {
        if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView(frame: keyWindow.frame)
            view.backgroundColor = UIColor.white
            
            view.frame = CGRect(x: 0, y: keyWindow.frame.height, width: keyWindow.frame.width, height: 10)
            
            let height = keyWindow.frame.width * 9 / 16
            let videoPlayerFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
            
            view.addSubview(videoPlayerView)
            
            keyWindow.addSubview(view)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
                
                view.frame = keyWindow.frame
                
            } completion: { (completedAnimation) in
                //maybe use it
                //UIApplication.shared.setStatusBarHidden(true, with: .fade)
            }
        }
    }
}
