//
//  PlayerViewModel.swift
//  testIos
//
//  Created by seth on 16/01/2023.
//

import AVFoundation
import Combine

final class PlayerViewModel: ObservableObject {
  let player = AVPlayer()
  @Published var isInPipMode: Bool = false
  @Published var isPlaying = false
  
  @Published var isEditingCurrentTime = false
  @Published var currentTime: Double = .zero
  @Published var duration: Double?
  @Published var movieDuration: String = "00:00:00"
  @Published var currenTimeString: String = "00:00:00"
  @Published var playlist: [Media] = []
  
  private var subscriptions: Set<AnyCancellable> = []
  private var timeObserver: Any?
  
  deinit {
    if let timeObserver = timeObserver {
      player.removeTimeObserver(timeObserver)
    }
  }
  
  init() {
    $isEditingCurrentTime
      .dropFirst()
      .filter({ $0 == false })
      .sink(receiveValue: { [weak self] _ in
        guard let self = self else { return }
        self.player.seek(to: CMTime(seconds: self.currentTime, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)
        if self.player.rate != 0 {
          self.player.play()
        }
      })
      .store(in: &subscriptions)
    
    player.publisher(for: \.timeControlStatus)
      .sink { [weak self] status in
        switch status {
        case .playing:
          self?.isPlaying = true
        case .paused:
          self?.isPlaying = false
        case .waitingToPlayAtSpecifiedRate:
          break
        @unknown default:
          break
        }
      }
      .store(in: &subscriptions)
    
    timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 600), queue: .main) { [weak self] time in
      guard let self = self else { return }
      if self.isEditingCurrentTime == false {
        self.currentTime = time.seconds
        // get movie current time
        let timeElapsed = time.seconds
        let secs = Int(timeElapsed)
        self.currenTimeString = NSString(format: "%02d:%02d:%02d", secs/3600, (secs % 3600) / 60, (secs % 3600) % 60) as String
      }
      // get movie duration
      let vl = Float(self.player.currentTime().seconds / (self.player.currentItem?.duration.seconds)!)
      if vl > 0 {
      let dur = CMTimeGetSeconds(self.player.currentItem?.duration ?? CMTime(value: 1, timescale: 10))
      let dursecs = Int(dur)
      self.movieDuration = NSString(format: "%02d:%02d:%02d", dursecs/3600, (dursecs % 3600) / 60, (dursecs % 3600) % 60) as String
      } else {
        self.movieDuration = "00:00:00"
      }
    }
  }
  
  func addMovie() {
    playlist = [
      .init(title: "First video", url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4")
    ]
  }
  
  func setCurrentItem(_ item: AVPlayerItem) {
    currentTime = .zero
    duration = nil
    player.replaceCurrentItem(with: item)
    
    item.publisher(for: \.status)
      .filter({ $0 == .readyToPlay })
      .sink(receiveValue: { [weak self] _ in
        self?.duration = item.asset.duration.seconds
      })
      .store(in: &subscriptions)
  }
}
