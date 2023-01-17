//
//  ContentView.swift
//  testIos
//
//  Created by seth on 12/01/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//      WindowGroup {
//        NavigationView {
          CustomPlayerView()
            .navigationTitle("CustomVideoPlayer")
//        }
//      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
