//
//  AVPlayerView.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 10.04.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import AVFoundation
import UIKit

final class AVPlayerView: UIView {

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    // MARK: - Overrides
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    // MARK: - Public
    var scaleMode: PlayerScaleMode {
        get {
            return playerLayer.videoGravity.scaleMode
        }
        set (value) {
            playerLayer.videoGravity = value.videoGravity
        }
    }

    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set (value) {
            playerLayer.player = value
        }
    }

    // MARK: - Private
    private var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

    private func initialize() {
        backgroundColor = .black
        isUserInteractionEnabled = false
        scaleMode = .fill
        clipsToBounds = true
    }
}

private extension PlayerScaleMode {

    var videoGravity: AVLayerVideoGravity {
        switch self {
        case .fit:
            return .resizeAspect
        case .fill:
            return .resizeAspectFill
        case .stretch:
            return .resize
        }
    }
}

private extension AVLayerVideoGravity {

    var scaleMode: PlayerScaleMode {
        switch self {
        case .resizeAspect:
            return .fit
        case .resizeAspectFill:
            return .fill
        default:
            return .stretch
        }
    }
}
