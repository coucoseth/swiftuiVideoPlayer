//
//  Media.swift
//  testIos
//
//  Created by seth on 16/01/2023.
//

import Foundation
import AVFoundation

struct Media: Identifiable {
  let id = UUID()
  let title: String
  let url: String
}

extension Media {
  var asPlayerItem: AVPlayerItem {
    AVPlayerItem(url: URL(string: url)!)
  }
}
