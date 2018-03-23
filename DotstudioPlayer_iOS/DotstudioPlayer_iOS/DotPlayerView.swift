//
//  DotPlayerView.swift
//  DotstudioPlayer_iOS
//
//  Created by Ketan Sakariya on 01/03/18.
//  Copyright © 2018 Ketan Sakariya. All rights reserved.
//

import UIKit
import AVKit


enum DotPlayerNibViewType: Int {
    case mainView = 0
    case regularControlsView = 1
    case liveControlsView = 2
//    case regularControlsView = 3
}

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
    
    public var viewPlayerControls: DotPlayerControlsView?
    var videoTapRecognizer: UITapGestureRecognizer?
//    var viewLivePlayerControls: DotLivePlayerControlsView?
    var isPlaying: Bool = false
    
    @IBInspectable open var showTopBarControls: Bool = false {
        didSet {
            
        }
    }
    @IBInspectable open var showBottomBarControls: Bool = false {
        didSet {
            
        }
    }

//    public override func awakeFromNib() {
//        super.awakeFromNib()
//        
//    }
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

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.viewPlayerControls?.frame = self.playerController.view.bounds
        self.viewPlayerControls?.showTopBarControls = self.showTopBarControls
        self.viewPlayerControls?.showBottomBarControls = self.showBottomBarControls
        self.contentView.sendSubview(toBack: playerController.view)
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
        let strVideoUrl_ = strVideoUrl //"https://k7q5a5e5.ssl.hwcdn.net/files/company/53fd1266d66da833047b23c6/assets/videos/540f28fdd66da89e1ed70281/vod/540f28fdd66da89e1ed70281.m3u8" //http://static.videokart.ir/clip/100/480.mp4"
        if let url : URL = URL(string: strVideoUrl_) {
            let player = AVPlayer(url: url)
//            let playerLayer = AVPlayerLayer(player: player)
//            playerLayer.frame = self.bounds
//            self.contentView.layer.addSublayer(playerLayer)
            self.player = player
            
            self.playerController.player = player
//            self.addChildViewController(playerController)
            
            self.playerController.showsPlaybackControls = false
            self.contentView.addSubview(playerController.view)
            self.contentView.sendSubview(toBack: playerController.view)
            self.playerController.view.frame = self.contentView.frame
            
            self.addControlsContentView()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func addControlsContentView() {
//        self.addRegularPlayerControlsContentView()
        self.addLivePlayerControlsContentView()
        
    }
    func addRegularPlayerControlsContentView() {
        
    }
    func addLivePlayerControlsContentView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        if let views = nib.instantiate(withOwner: self, options: nil) as? [UIView] {
            if views.count > 2 {
                if let viewLivePlayerControls = views[2] as? DotLivePlayerControlsView {
                    self.viewPlayerControls = viewLivePlayerControls
                    self.videoTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DotPlayerView.showFullscreenControls(_:)))
                    self.playerController.contentOverlayView?.addGestureRecognizer(self.videoTapRecognizer!)
                    viewLivePlayerControls.delegate = self
                    if let contentOverlayView = self.playerController.contentOverlayView {
                        contentOverlayView.addSubview(viewLivePlayerControls)
                        viewLivePlayerControls.frame = self.playerController.view.bounds //
                    }
                }
            }
        }
    }
    
    @objc func showFullscreenControls(_ recognizer: UITapGestureRecognizer?) {
        self.viewPlayerControls?.isHidden = false
        self.viewPlayerControls?.alpha = 0.9
        startHideControlsTimer()
    }
    func startHideControlsTimer() {
        self.perform(#selector(DotPlayerView.hideFullscreenControls), with: self, afterDelay: 3)
    }
    
    @objc func hideFullscreenControls() {
        UIView.animate(withDuration: 0.5, animations: {
            self.viewPlayerControls?.alpha = 0.0
        }) { (bValue) in
            self.viewPlayerControls?.isHidden = true
        }
        
    }
    
    func addConstraint(_ subView: UIView, superView: UIView) {
        // Width constraint, half of parent view width
        superView.addConstraints([
            NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: superView, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: superView, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: superView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: superView, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0)
            
            ])
    }

    public func play() {
        self.player?.play()
        self.isPlaying = true
//        self.viewLivePlayerControls?.buttonPlay?.setImage(#imageLiteral(resourceName: "pause-icon"), for: .normal)
        self.viewPlayerControls?.play() //buttonPlay?.isSelected = true
    }
    
    public func pause() {
        self.player?.pause()
        self.isPlaying = false
//        self.viewLivePlayerControls?.buttonPlay?.setImage(#imageLiteral(resourceName: "play-icon"), for: .normal)
        self.viewPlayerControls?.pause() //buttonPlay?.isSelected = false
    }
    
    public func toggleFullscreen() {
        self.isFullScreen = !self.isFullScreen
        if self.isFullScreen {
            var value = UIInterfaceOrientation.landscapeLeft.rawValue
            if UIDevice.current.orientation == .landscapeRight {
                value = UIInterfaceOrientation.landscapeRight.rawValue
            }
            UIDevice.current.setValue(value, forKey: "orientation")
//            if let window = self.window {
//                self.playerController.view.removeFromSuperview()
//                window.addSubview(self.playerController.view)
//                self.playerController.view.frame = window.bounds
//                let value = UIInterfaceOrientation.landscapeLeft.rawValue
//                UIDevice.current.setValue(value, forKey: "orientation")
//            }
        } else {
//            self.playerController.view.removeFromSuperview()
//            self.contentView.addSubview(playerController.view)
//            playerController.view.frame = self.contentView.frame
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
    }
    
    @objc func rotated() {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            print("Landscape")
            if let window = self.window {
                self.playerController.view.removeFromSuperview()
                window.addSubview(self.playerController.view)
                self.playerController.view.frame = window.bounds
            }
        } else if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            print("Portrait")
            self.playerController.view.removeFromSuperview()
            self.contentView.addSubview(playerController.view)
            playerController.view.frame = self.contentView.frame
        }
        self.layoutSubviews()
    }
//    func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        if UIDevice.current.orientation.isLandscape {
//            print("Landscape")
//            self.viewLivePlayerTicker.isHidden = false
//            //            self.dotPlayerView.bringSubview(toFront: self.viewLivePlayerTicker)
//            UIApplication.shared.isStatusBarHidden = true
//        } else {
//            print("Portrait")
//            self.viewLivePlayerTicker.isHidden = true
//            //            self.dotPlayerView.bringSubview(toFront: self.viewLivePlayerTicker)
//            UIApplication.shared.isStatusBarHidden = false
//        }
//    }
    
}

extension DotPlayerView: DotLivePlayerControlsViewDelegate {
    func didTriggerActionForPlayButton(_ sender: Any) {
        print("play button triggered")
        if self.isPlaying {
            self.pause()
        } else {
            self.play()
        }
    }
    func didTriggerActionForExpandButton(_ sender: Any) {
        self.toggleFullscreen()
    }
}




