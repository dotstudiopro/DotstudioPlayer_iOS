//
//  DotPlayerView.swift
//  DotstudioPlayer_iOS
//
//  Created by Ketan Sakariya on 01/03/18.
//  Copyright © 2018 Ketan Sakariya. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

enum DotPlayerNibViewType: Int {
    case mainView = 0
    case regularControlsView = 1
    case liveControlsView = 2
//    case regularControlsView = 3
}

public protocol DotPlayerViewDelegate {
    func didPlayerBecomeReady(_ dotPlayerObject: DotPlayerObject)
    func didFailedToLoadPlayer(_ dotPlayerObject: DotPlayerObject)
    func didPlayDotPlayerVideo(_ dotPlayerObject: DotPlayerObject)
    func didPauseDotPlayerVideo(_ dotPlayerObject: DotPlayerObject)
    func didResumeDotPlayerVideo(_ dotPlayerObject: DotPlayerObject)
    func didEndPlaybackDotPlayerVideo(_ dotPlayerObject: DotPlayerObject)
}
private var playerViewControllerKVOContext = 0

public class DotPlayerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    public var delegate: DotPlayerViewDelegate?
    let nibName = "DotPlayerView"
    var contentView: UIView!
    let playerController = AVPlayerViewController()
    @objc let player: AVPlayer = AVPlayer()
    private var playerItem: AVPlayerItem? = nil {
        didSet {
            /*
             If needed, configure player item here before associating it with a player.
             (example: adding outputs, setting text style rules, selecting media options)
             */
            player.replaceCurrentItem(with: self.playerItem)
        }
    }
    var currentTime: Double {
        get {
            return CMTimeGetSeconds(player.currentTime())
        }
        set {
            let newTime = CMTimeMakeWithSeconds(newValue, 1)
            player.seek(to: newTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        }
    }
    
    var duration: Double {
        guard let currentItem = player.currentItem else { return 0.0 }
        
        return CMTimeGetSeconds(currentItem.duration)
    }
    
    var rate: Float {
        get {
            return player.rate
        }
        
        set {
            player.rate = newValue
        }
    }
    
    @IBOutlet weak var label: UILabel!
    var isFullScreen: Bool = false
    
    public var viewPlayerControls: DotPlayerControlsView?
    var videoTapRecognizer: UITapGestureRecognizer?
//    var viewLivePlayerControls: DotLivePlayerControlsView?
    var isPlaying: Bool = false
//    var isLiveStreaming: Bool = false
    var dotPlayerObject: DotPlayerObject?
    public var viewContentOverlayPlayerController: UIView?
    
    @IBInspectable open var showTopBarControls: Bool = false {
        didSet {
            
        }
    }
    @IBInspectable open var showBottomBarControls: Bool = false {
        didSet {
            
        }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
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

    func registerObservers() {
        self.addObserver(self, forKeyPath: #keyPath(DotPlayerView.player.currentItem.duration), options: [.new, .initial], context: &playerViewControllerKVOContext)
        self.addObserver(self, forKeyPath: #keyPath(DotPlayerView.player.rate), options: [.new, .initial], context: &playerViewControllerKVOContext)
        self.addObserver(self, forKeyPath: #keyPath(DotPlayerView.player.currentItem.status), options: [.new, .initial], context: &playerViewControllerKVOContext)
    }
    func deregisterObservers() {
        self.removeObserver(self, forKeyPath: #keyPath(DotPlayerView.player.currentItem.duration), context: &playerViewControllerKVOContext)
        self.removeObserver(self, forKeyPath: #keyPath(DotPlayerView.player.rate), context: &playerViewControllerKVOContext)
        self.removeObserver(self, forKeyPath: #keyPath(DotPlayerView.player.currentItem.status), context: &playerViewControllerKVOContext)
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
    
    //MARK: - Key Value Observing
    // Update our UI when player or `player.currentItem` changes.
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        // Make sure the this KVO callback was intended for this view controller.
        guard context == &playerViewControllerKVOContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == #keyPath(player.currentItem.duration) {
            // Update timeSlider and enable/disable controls when duration > 0.0
            
            /*
             Handle `NSNull` value for `NSKeyValueChangeNewKey`, i.e. when
             `player.currentItem` is nil.
             */
            let newDuration: CMTime
            if let newDurationAsValue = change?[NSKeyValueChangeKey.newKey] as? NSValue {
                newDuration = newDurationAsValue.timeValue
            }
            else {
                newDuration = kCMTimeZero
            }
            
            let hasValidDuration = newDuration.isNumeric && newDuration.value != 0
            let newDurationSeconds = hasValidDuration ? CMTimeGetSeconds(newDuration) : 0.0
            let currentTime = hasValidDuration ? Float(CMTimeGetSeconds(player.currentTime())) : 0.0
            
        }
        else if keyPath == #keyPath(player.rate) {
            // Update `playPauseButton` image.
            let newRate = (change?[NSKeyValueChangeKey.newKey] as! NSNumber).doubleValue
            if let dotPlayerObject = self.dotPlayerObject {
//                if newRate == 1.0 {
//                    self.delegate?.didPauseDotPlayerVideo(dotPlayerObject)
//                } else {
//                    self.delegate?.didPlayDotPlayerVideo(dotPlayerObject)
//                }
            }
        }
        else if keyPath == #keyPath(player.currentItem.status) {
            // Display an error if status becomes `.Failed`.
            
            /*
             Handle `NSNull` value for `NSKeyValueChangeNewKey`, i.e. when
             `player.currentItem` is nil.
             */
            let newStatus: AVPlayerItemStatus
            
            if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                newStatus = AVPlayerItemStatus(rawValue: newStatusAsNumber.intValue)!
            }
            else {
                newStatus = .unknown
            }
            
            switch newStatus {
                case .unknown:
                    break
                case .failed:
                    if let dotPlayerObject = self.dotPlayerObject {
                        self.delegate?.didFailedToLoadPlayer(dotPlayerObject)
                    }
                    break
                case .readyToPlay:
                    if let dotPlayerObject = self.dotPlayerObject {
                        self.delegate?.didPlayerBecomeReady(dotPlayerObject)
                    }
                    break
                default: break
            }
//            if newStatus == .failed {
////                handleErrorWithMessage(player.currentItem?.error?.localizedDescription, error:player.currentItem?.error)
//            }
        }
    }
    
    //MARK: - Set Player methods.
    public func setPlayerObject(_ dotPlayerObject: DotPlayerObject) {
        self.dotPlayerObject = dotPlayerObject
//        let strVideoUrl_ = strVideoUrl //"https://k7q5a5e5.ssl.hwcdn.net/files/company/53fd1266d66da833047b23c6/assets/videos/540f28fdd66da89e1ed70281/vod/540f28fdd66da89e1ed70281.m3u8" //http://static.videokart.ir/clip/100/480.mp4"
        if let strVideoUrl = dotPlayerObject.strVideoUrl {
            if let url : URL = URL(string: strVideoUrl) {
//                let player = AVPlayer(url: url)
//                self.player = player
                self.playerItem = AVPlayerItem(url: url)
                
                self.playerController.player = player
                self.playerController.showsPlaybackControls = false
                self.contentView.addSubview(playerController.view)
                self.contentView.sendSubview(toBack: playerController.view)
                self.playerController.view.frame = self.contentView.frame
                
                self.addControlsContentView()
                
                self.viewContentOverlayPlayerController = self.playerController.contentOverlayView
            }
            
//            NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
            
        }

    }
    
    func addControlsContentView() {
        if let isLiveStreaming = self.dotPlayerObject?.isLiveStreaming, isLiveStreaming == true {
            self.addLivePlayerControlsContentView()
        } else {
            //        self.addRegularPlayerControlsContentView()
        }
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
        self.layer.removeAllAnimations()
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
        if let isLiveStreaming = self.dotPlayerObject?.isLiveStreaming, isLiveStreaming == true {
            guard let livePosition = self.player.currentItem?.seekableTimeRanges.last as? CMTimeRange else {
                return
            }
            self.player.seek(to:CMTimeRangeGetEnd(livePosition))
        }
        
        self.player.play()
        self.isPlaying = true
        if let dotPlayerObject = self.dotPlayerObject {
//            self.delegate?.didPlayDotPlayerVideo(dotPlayerObject)
            self.delegate?.didResumeDotPlayerVideo(dotPlayerObject)
        }
//        self.playerController.player = self.player
//        self.viewLivePlayerControls?.buttonPlay?.setImage(#imageLiteral(resourceName: "pause-icon"), for: .normal)
        self.viewPlayerControls?.play() //buttonPlay?.isSelected = true
        self.startHideControlsTimer()
    }
    
    public func pause() {
        self.player.pause()
        self.isPlaying = false
        if let dotPlayerObject = self.dotPlayerObject {
            self.delegate?.didPauseDotPlayerVideo(dotPlayerObject)
        }
//        self.playerController.player = nil
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
//            UIApplication.shared.isStatusBarHidden = true
        } else if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            print("Portrait")
            self.playerController.view.removeFromSuperview()
            self.contentView.addSubview(playerController.view)
            playerController.view.frame = self.contentView.frame
//            UIApplication.shared.isStatusBarHidden = false
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
    
    func setVideoWaterMark(dotPlayerObject: DotPlayerObject) {
        
    }

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




