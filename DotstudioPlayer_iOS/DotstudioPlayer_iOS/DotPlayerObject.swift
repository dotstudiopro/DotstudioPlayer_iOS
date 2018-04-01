//
//  DotPlayerObject.swift
//  DotstudioPlayer_iOS
//
//  Created by Ketan Sakariya on 30/03/18.
//  Copyright © 2018 Ketan Sakariya. All rights reserved.
//

import Foundation

public class DotPlayerObject: NSObject {
    public var videoDict: [String: AnyObject] = [:]
    public var isLiveStreaming: Bool = false
    public var strVideoUrl: String?
    public var isWaterMarkingEnabled: Bool = false
    public var strWaterMarkUrl: String?
    public var fWaterMarkOpacity: CGFloat?
    public var fWaterMarkXOffset: CGFloat = 10.0
    public var fWaterMarkYOffset: CGFloat = 10.0
    public var sizeWaterMark: CGSize = CGSize(width: 100.0, height: 30.0)
    public var iDuration: Int = 0
    
    
    public override init() {
        super.init()
    }
}





