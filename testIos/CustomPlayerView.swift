//
//  CustomPlayerView.swift
//  testIos
//
//  Created by seth on 16/01/2023.
//

import SwiftUI
import AVFoundation

struct CustomPlayerView: View {
  @StateObject private var playerVM = PlayerViewModel()
//  @State private var playlist: [Media] = Media.playlist
  @State var showControls = true
  
  init() {
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setCategory(.playback)
    } catch {
      print("Setting category to AVAudioSessionCategoryPlayback failed.")
    }
  }
  
  var body: some View {
    VStack {
      ZStack {
        CustomVideoPlayer(playerVM: playerVM)
        if self.showControls {
          CustomControlsView(playerVM: playerVM, panel: $showControls)
        }
      }
      .frame(height: UIScreen.main.bounds.height)
      .overlay(playerVM.isInPipMode ? List(playerVM.playlist) { media in
        Button(media.title) {
          playerVM.setCurrentItem(media.asPlayerItem)
        }
      } : nil)
    }
    .onTapGesture {
      self.showControls = true
    }
    .onAppear {
      playerVM.addMovie()
      playerVM.setCurrentItem(playerVM.playlist.first!.asPlayerItem)
      playerVM.player.play()
    }
    .onDisappear {
      playerVM.player.pause()
    }
    .frame(
      maxWidth: .infinity,
      maxHeight: .infinity,
      alignment: .center
    )
    .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.003, green: 0.01, blue: 0.092)/*@END_MENU_TOKEN@*/)
    .ignoresSafeArea()
  }
}
