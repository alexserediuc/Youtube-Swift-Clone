//
//  VideoPlayerView.swift
//  Youtube Clone
//
//  Created by Alex on 11/10/2021.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    let keyWindow = UIApplication.shared.keyWindow!
    private var isDragging = false
    private var isMinimised = false
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = UIColor.white
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    lazy var minimizeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "arrow.down")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleMinimize), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleMinimize() {
        minimizePlayerView()
    }
    
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "pause.fill")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        
        return button
    }()
    
    var isPlaying = false
    
    @objc func handlePause() {
        if isPlaying {
            player?.pause()
            pausePlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player?.play()
            pausePlayButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        isPlaying = !isPlaying
    }
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "xmark")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()
    
    @objc func handleClose() {
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        superview?.removeFromSuperview()
        self.removeFromSuperview()
    }
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    
    let curretTimelabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var videoSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
        let image = UIImage(named: "circle.fill")
        slider.setThumbImage(image, for: .normal)
        slider.thumbTintColor = .red
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    
    @objc func handleSliderChange() {
        print(videoSlider.value)
        
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            
            let value = Float64(videoSlider.value) * totalSeconds
            
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            
            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
                //do smth
            })
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupPlayerView()
        
        setupGradientLayer()
        
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        
        controlsContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        controlsContainerView.addSubview(minimizeButton)
        minimizeButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        minimizeButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        controlsContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        controlsContainerView.addSubview(curretTimelabel)
        curretTimelabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        curretTimelabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        curretTimelabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        curretTimelabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        controlsContainerView.addSubview(videoSlider)
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: curretTimelabel.rightAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        backgroundColor = .black
        
    }
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    private func setupPlayerView() {
        let urlString = "https://wolverine.raywenderlich.com/content/ios/tutorials/video_streaming/foxVillage.mp4"
        if let url = URL(string: urlString) {
            player = AVPlayer(url: url)
            playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer!)
            playerLayer?.frame = self.frame
            player?.play()
            
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            
            //Track progress
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
                
                let seconds = CMTimeGetSeconds(progressTime)
                let secondsString = String(format: "%02d", Int(seconds) % 60)
                let minutesString = String(format: "%02d", Int(seconds) / 60)
                self.curretTimelabel.text = "\(minutesString):\(secondsString)"
                
                //move the slider
                if let duration = self.player?.currentItem?.duration {
                    let durationSconds = CMTimeGetSeconds(duration)
                    
                    
                    self.videoSlider.value = Float(seconds / durationSconds)
                    
                }
            })
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        //player ready and going
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = .clear
            pausePlayButton.isHidden = false
            isPlaying = true
            
            //fkin cmtime
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                
                if(seconds > 0){
                let secondsText = Int(seconds) % 60
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                
                videoLengthLabel.text = "\(minutesText):\(secondsText)"
                }
            }
        }
    }
    
    let gradientLayer = CAGradientLayer()
    private func setupGradientLayer() {
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1.2]
        controlsContainerView.layer.addSublayer(gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if self.bounds.contains(location) {
            print("initial touch: \(location)")
            isDragging = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDragging, let touch = touches.first else {return}
        
        let view = UIView(frame: UIApplication.shared.keyWindow!.frame)
        let location = touch.location(in: view)
        self.superview!.frame.origin.y = location.y - (self.frame.size.height/2)
        print(location.y)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDragging = false
        
        guard let touch = touches.first else {return}
        
        let view = UIView(frame: UIApplication.shared.keyWindow!.frame)
        let location = touch.location(in: view)
        if location.y < UIApplication.shared.keyWindow!.frame.height/3 {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
                self.superview!.frame = UIApplication.shared.keyWindow!.frame
            }
        } else {
            minimizePlayerView()
            
        }
    }
    
    private func minimizePlayerView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) { [self] in
            
            guard let sv = superview else {return}
            
            let height = keyWindow.frame.width/3 * 9 / 16
            let width = keyWindow.frame.width
            sv.frame = CGRect(x: 0, y: keyWindow.frame.height-height-50, width: keyWindow.frame.width, height: height)
            frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            playerLayer?.frame = CGRect(x: 0, y: 0, width: width/3, height: height)
            controlsContainerView.removeFromSuperview()
            
            addSubview(closeButton)
            closeButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            closeButton.rightAnchor.constraint(equalTo: rightAnchor,constant: -10).isActive = true
            
            addSubview(pausePlayButton)
            pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            pausePlayButton.rightAnchor.constraint(equalTo: closeButton.leftAnchor).isActive = true
            
            addSubview(videoSlider)
            videoSlider.thumbTintColor = UIColor.clear
            videoSlider.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            videoSlider.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            videoSlider.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            isMinimised = true
            
        }
    }
}

