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
}

class DotPlayerControlsView: UIView {
    var delegate: DotPlayerControlsViewDelegate?

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func didTriggerActionForExpandButton(_ sender: Any) {
        print("Expand Button Action Triggered.")
        self.delegate?.didTriggerActionForExpandButton(self)
    }
    
}
