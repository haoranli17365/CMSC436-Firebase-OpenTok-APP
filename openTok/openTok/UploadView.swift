//
//  UploadView.swift
//  openTok
//
//  Created by HLi on 4/29/21.
//

import SwiftUI
import Firebase

struct UploadView: View {
    @State private var name:String = ""
    @State private var url:String = ""
    @State private var is_edit:Bool = false
    var body: some View {
        ZStack {
            NavigationView{
                Form(){
                    // name field
                    Text("Video Name:").bold()
                    TextField("Name:", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .padding()
                    // url field
                    Text("Video URL:").bold()
                    TextField("URL:",text: $url)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .padding()
                    // upload button
                    Button("Upload Video"){ upload(name: name, url: url)}
                        .buttonStyle(BlueButton())
                        .frame(width: 275, height: 100, alignment: .center)
                        .padding()
                }.navigationTitle("Upload File")
            }
        }
    }
    func upload(name:String, url:String) {
        let root = Database.database().reference()
        root.child("urls").childByAutoId().setValue(["name": "\(name)","url": "\(url)"])
    }
}

// custom button style
struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(18)
            .background(Color.blue)
            .foregroundColor(.white)
            .font(.title2)
            .cornerRadius(9.0)
            .scaleEffect(configuration.isPressed ? 0.95: 1)
            .animation(.spring())
            
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
    }
}
