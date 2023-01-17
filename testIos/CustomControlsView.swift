//
//  CustomControlsView.swift
//  testIos
//
//  Created by seth on 12/01/2023.
//

import SwiftUI
import AVFoundation

struct CustomControlsView: View {
  @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
  @ObservedObject var playerVM: PlayerViewModel
  @Binding var panel : Bool
  
  var body: some View {
    VStack{
      HStack{
        Button(action: {
          //          previewModel.lastWatchedPosition = currentTime
                    playerVM.player.pause()
          //          previewModel.addLastWatchedDuration()
          presentationMode.wrappedValue.dismiss()
          //          self.rotatePotrait()
        }, label: {
          Image(systemName: "chevron.left")
            .font(.title3)
            .foregroundColor(Color.white)
            .padding(20)
        })
        Text("Movie title")
          .font(.system(size: 14, design: .rounded))
          .foregroundColor(.white)
          .padding(.trailing, 10)
        Spacer()
        Button(action: {
          withAnimation {
            playerVM.isInPipMode.toggle()
          }
        }, label: {
          Image(systemName: playerVM.isInPipMode ? "pip.exit": "pip.enter")
            .font(.title3)
            .foregroundColor(Color.white)
            .padding(20)
        })
      }
      Spacer()
      HStack{
        Spacer()
          Button(action: {
            self.playerVM.player.seek(to: CMTime(seconds: self.playerVM.currentTime - 10, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)
            if self.playerVM.player.rate != 0 {
              self.playerVM.player.play()
            }
          }, label: {
            Image(systemName: "gobackward.10")
              .font(.title)
              .foregroundColor(Color.white)
              .padding(20)
          })
          Spacer()
          Button(action: {
            if playerVM.isPlaying{
              playerVM.player.pause()
            } else{
              playerVM.player.play()
            }
          }, label: {
            Image(systemName: playerVM.isPlaying ? "pause.fill" : "play.fill")
              .font(.title)
              .foregroundColor(Color.white)
              .padding(20)
          })
          Spacer()
          Button(action: {
            self.playerVM.player.seek(to: CMTime(seconds: self.playerVM.currentTime + 10, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)
            if self.playerVM.player.rate != 0 {
              self.playerVM.player.play()
            }
          }, label: {
            Image(systemName: "goforward.10")
              .font(.title)
              .foregroundColor(Color.white)
              .padding(20)
          })
        Spacer()
      }
      Spacer()
      HStack{
        Text(playerVM.currenTimeString)
          .font(.system(size: 14, design: .rounded))
          .foregroundColor(.white)
          .padding(.trailing, 10)
        if let duration = playerVM.duration {
          Slider(value: $playerVM.currentTime, in: 0...duration, onEditingChanged: { isEditing in
            playerVM.isEditingCurrentTime = isEditing
          })
        } else {
          Spacer()
        }
        Text(playerVM.movieDuration)
          .font(.system(size: 14, design: .rounded))
          .foregroundColor(.white)
          .padding(.leading, 10)
      }
    }
    .padding()
    .background(Color.black.opacity(0.4))
    .onTapGesture {
      self.panel = false
    }
  }
}
