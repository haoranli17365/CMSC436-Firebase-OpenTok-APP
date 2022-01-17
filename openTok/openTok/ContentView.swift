//
//  ContentView.swift
//  openTok
//
//  Created by HLi on 4/29/21.
//

import SwiftUI
import Firebase
struct ContentView: View {
    var body: some View {
        TabView{
            PlayerView()
                .tabItem {
                    Image(systemName: "video.fill")
                    Text("Player")
                }
            UploadView()
                .tabItem {
                    Image(systemName: "icloud.and.arrow.up.fill")
                    Text("Upload")
                }
        }.onAppear{
            // configure at launch time
            FirebaseApp.configure()
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
