//
//  DotPlayerControlsView.swift
//  DotstudioPlayer_iOS
//
//  Created by Ketan Sakariya on 01/03/18.
//  Copyright © 2018 Ketan Sakariya. All rights reserved.
//

import UIKit

protocol DotPlayerControlsViewDelegate {
    func didTriggerActionForExpandButton(_ sender: Any)
    func didTriggerActionForPlayButton(_ sender: Any)
    func didTriggerActionForCastButton(_ sender: Any)
    func didTriggerActionForShareButton(_ sender: Any)
}

public class DotPlayerControlsView: UIView {
//    var delegate: DotPlayerControlsViewDelegate?

    @IBOutlet weak var buttonPlay: UIButton?
    @IBOutlet weak var buttonBigPlay: UIButton?
    @IBOutlet weak var buttonExpand: UIButton?
    @IBOutlet weak var buttonCast: UIButton?
    @IBOutlet weak var buttonShare: UIButton?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var useTopBarControls: Bool = true
    var useBottomBarControls: Bool = true
    
    @IBOutlet public weak var imageViewWatermark: UIImageView?
    @IBOutlet public weak var constraintWatermarkXOffset: NSLayoutConstraint?
    @IBOutlet public weak var constraintWatermarkYOffset: NSLayoutConstraint?
    @IBOutlet public weak var constraintWatermarkWidth: NSLayoutConstraint?
    @IBOutlet public weak var constraintWatermarkHeight: NSLayoutConstraint?

    @IBOutlet weak var viewTopBar: EZYGradientView?
    @IBOutlet weak var viewBottomBar: EZYGradientView?
    
    
    public func play() {
    }
    public func pause() {
    }
    
    @IBAction func didTriggerActionForExpandButton(_ sender: Any) {
        print("Expand Button Action Triggered.")
        //self.delegate?.didTriggerActionForExpandButton(self)
    }
    @IBAction func didTriggerActionForPlayButton(_ sender: Any) {
        print("play Button Action Triggered.")
    }
    @IBAction func didTriggerActionForCastButton(_ sender: Any) {
        print("cast Button Action Triggered.")
    }
    @IBAction func didTriggerActionForShareButton(_ sender: Any) {
        print("share Button Action Triggered.")
    }
    func setVideoWaterMark(dotPlayerObject: DotPlayerObject) {
        if dotPlayerObject.isWaterMarkingEnabled {
            self.imageViewWatermark?.isHidden = false
            if let strWaterMarkUrl = dotPlayerObject.strWaterMarkUrl {
                if let fWaterMarkOpacity = dotPlayerObject.fWaterMarkOpacity {
                    self.imageViewWatermark?.alpha = fWaterMarkOpacity
                }
                if let url = URL(string: strWaterMarkUrl) {
                    //self.imageViewWatermark?.setImage.splt_setImageFromURL(url, placeholder: nil)
                } else {
                    self.imageViewWatermark?.image = nil
                }
            } else {
                self.imageViewWatermark?.image = nil
            }
        } else {
            self.imageViewWatermark?.isHidden = true
        }
        // Set Watermark Offset
        self.constraintWatermarkXOffset?.constant = dotPlayerObject.fWaterMarkXOffset
        self.constraintWatermarkYOffset?.constant = dotPlayerObject.fWaterMarkYOffset
        self.constraintWatermarkWidth?.constant = dotPlayerObject.sizeWaterMark.width
    }
}
