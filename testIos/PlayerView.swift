//
//  PlayerView.swift
//  testIos
//
//  Created by seth on 16/01/2023.
//

import AVFoundation
import UIKit

final class PlayerView: UIView {
  override static var layerClass: AnyClass {
    return AVPlayerLayer.self
  }
  
  var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
  
  var player: AVPlayer? {
    get {
      playerLayer.player
    }
    set {
      playerLayer.videoGravity = .resizeAspect
      playerLayer.player = newValue
    }
  }
}
