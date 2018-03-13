//
//  DotPlayerView.swift
//  DotstudioPlayer_iOS
//
//  Created by Ketan Sakariya on 01/03/18.
//  Copyright © 2018 Ketan Sakariya. All rights reserved.
//

import UIKit
import AVKit

public class DotPlayerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let nibName = "DotPlayerView"
    var contentView: UIView!
    let playerController = AVPlayerViewController()
    var player : AVPlayer?
    @IBOutlet weak var label: UILabel!
    var isFullScreen: Bool = false
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        //setUpView()
        commonInit()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setUpView() //called when setup from storyboard class
        commonInit()
    }

    public func getTestString() -> String {
        return "DotPlayer String"
    }
//    private func setUpView() {
//        let bundle = Bundle(for: type(of: self))
//        let nib = UINib(nibName: self.nibName, bundle: bundle)
//        self.contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
//        addSubview(contentView)
//
//        contentView.center = self.center
//        contentView.frame = self.bounds
//        contentView.autoresizingMask = []
//        contentView.translatesAutoresizingMaskIntoConstraints = true
//    }
//    func loadNib() -> UIView {
//        let bundle = Bundle(for: type(of: self))
////        let nibName = type(of: self).description().components(separatedBy: ".").last!
//        let nib = UINib(nibName: self.nibName, bundle: bundle)
//        return nib.instantiate(withOwner: self, options: nil).first as! UIView
//    }
    
    private func commonInit() {
        //let bundle = Bundle(for: type(of: self))
//        Bundle.main.loadNibNamed("DotPlayerView", owner: self, options: nil)
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(contentView)
        
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    public func set(strVideoUrl: String) {
        let strVideoUrl_ = "https://k7q5a5e5.ssl.hwcdn.net/files/company/53fd1266d66da833047b23c6/assets/videos/540f28fdd66da89e1ed70281/vod/540f28fdd66da89e1ed70281.m3u8" //http://static.videokart.ir/clip/100/480.mp4"
        if let url : URL = URL(string: strVideoUrl_) {
            let player = AVPlayer(url: url)
//            let playerLayer = AVPlayerLayer(player: player)
//            playerLayer.frame = self.bounds
//            self.contentView.layer.addSublayer(playerLayer)
            self.player = player
            
            playerController.player = player
//            self.addChildViewController(playerController)
            
            self.playerController.showsPlaybackControls = false
            self.contentView.addSubview(playerController.view)
            self.contentView.sendSubview(toBack: playerController.view)
            playerController.view.frame = self.contentView.frame
            
        }
    }
    public func play() {
        self.player?.play()
    }
    
    public func stop() {
        self.player?.pause()
    }
    
    func toggleFullscreen() {
        self.isFullScreen = !self.isFullScreen
        if self.isFullScreen {
            if let window = self.window {
                self.playerController.view.removeFromSuperview()
                window.addSubview(self.playerController.view)
                self.playerController.view.frame = window.bounds
            }
        } else {
            self.playerController.view.removeFromSuperview()
            self.contentView.addSubview(playerController.view)
            playerController.view.frame = self.contentView.frame
        }
    }
}

extension DotPlayerView: DotPlayerControlsViewDelegate {
    func didTriggerActionForExpandButton(_ sender: Any) {
        self.toggleFullscreen()
    }
}




