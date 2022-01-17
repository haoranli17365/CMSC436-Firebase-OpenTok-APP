//
//  PlayerView.swift
//  openTok
//
//  Created by HLi on 4/29/21.
//

import SwiftUI
import AVKit
import Firebase

struct PlayerView: View {
    // all the video fetched from database
    @State var video_list:[Video] = []
    
    @State var curr_video:Video = Video(id: "cover", name: "OpenTok", url: "https://bit.ly/swswift", like: 0)
    @State var curr_idx:Int = 0
    @State var curr_like:Int = 0
    var body: some View {
        VStack{
            Text("\(curr_video.name)").font(.title2).bold()
            // video media player
            VideoPlayer(player: AVPlayer(url:URL(string: curr_video.url)!))
                .aspectRatio(contentMode: .fit)
                .gesture(DragGesture(minimumDistance: 100).onEnded{ event in
                    if (event.location.x - event.startLocation.x) > 0 { prev() }else{ next() }
                })
            // Like button
            Button(action: {
                like(curr_video.id)
                if curr_video.like == 0{ curr_video.like+=1; curr_like+=1 }
            }, label: {
                HStack{
                    ZStack{
                        Circle().foregroundColor(.gray).frame(width: 50, height: 50)
                        Text("👍").font(.title)
                    }
                    Text("\(curr_like)").font(.title)
                }
            }).onChange(of: curr_video.like, perform: { value in
                curr_like = curr_video.like
            })
            
            HStack{
                // Previous Button
                Button(action: { prev(); seen(curr_video.id) }, label: {
                    HStack{
                        Image(systemName: "arrowshape.turn.up.left.circle")
                        Text("Previous")
                    }
                }).buttonStyle(BlueButton())
                .frame(minWidth: 150, minHeight: 50)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue))
                .frame(width: 180, alignment: .center)
                
                // Next Button
                Button(action: { next(); seen(curr_video.id) }, label: {
                    HStack{
                        Text("Next")
                        Image(systemName: "arrowshape.turn.up.right.circle")
                    }
                }).buttonStyle(BlueButton())
                .frame(minWidth: 150, minHeight: 50)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue))
                .frame(width: 180, alignment: .center)
                
            }
            // Fetch Button
            Button("Update Video List"){
                retrieve_url_info()
            }.buttonStyle(BlueButton())
            .frame(width: 300, height: 100, alignment: .center)
        }.onAppear{
            set_observer()
        }
    }
    
    // next button function
    func next(){
        // check if there is video in list
        guard !video_list.isEmpty else { return }
        // if current one is hardcoded cover.
        if self.curr_video.id == "cover"{
            curr_video = video_list.first!
        }else{
            curr_idx += 1 // increament the index
            // if idx exceed the list idx, back to the first one
            if curr_idx >= video_list.count{
                curr_video = video_list.first!
                curr_idx = 0 // back to the first one
                retrieve_url_info() // refrom video_list by its like number
            }else{
                curr_video = video_list[curr_idx]
            }
        }
    }
    
    // previous button function
    func prev(){
        // check if there is video in list
        guard !video_list.isEmpty else { return }
        // if current one is hardcoded cover.
        if self.curr_video.id == "cover"{
            curr_video = video_list.last!
        }else{
            curr_idx -= 1 // decreament the index
            // if idx smaller than list idx bound, go to the last one
            if curr_idx < 0{
                curr_video = video_list.last!
                curr_idx = video_list.count - 1 // back to the last one
            }else{
                curr_video = video_list[curr_idx]
            }
        }
    }
    
    // upload like
    func like(_ id:String) {
        // don't update the cover video
        if id == "cover" { return }
        let root = Database.database().reference()
        root.child("urls/\(id)/like/hli12314").getData(){ (error, snapshot) in
            let curr_like:Int = snapshot.childSnapshot(forPath: "urls/\(id)/like/hli12314").value as? Int ?? 0
            if curr_like == 0{ // already liked
                root.child("urls/\(id)/like/hli12314").setValue(curr_like + 1)
            }
        }
    }
    
    // upload seen
    func seen(_ id:String){
        if id == "cover" { return }
        let root = Database.database().reference()
        root.child("seen/hli12314/\(id)").setValue(1)
    }
    
    // retrieve_url
    func retrieve_url_info(){
        let root = Database.database().reference()
        // when first time clicking on update URL Button:
        root.child("urls").getData() { (error, snapshot) in
            if snapshot.exists() {
                // clean video list up
                if !video_list.isEmpty{ video_list.removeAll() }
                // fetch all videos to local array
                let urls = snapshot.childSnapshot(forPath: "urls").value as? [String : [String: AnyObject]] ?? [:]
                for video in urls{
                    let like = snapshot.childSnapshot(forPath: "urls/\(video.key)/like").value as? [String:Int] ?? [:]
                    video_list.append(Video(id: video.key, name: video.value["name"]! as! String, url: video.value["url"]! as! String, like: like.count))
                }
                // Sort the video list
                let seen = snapshot.childSnapshot(forPath: "seen/hli12314").value as? [String: AnyObject] ?? [:]
                var seen_list:[String] = []
                for seen_vid in seen{ seen_list.append(seen_vid.key) }
                sort_video_list(seen_ids: seen_list)
            }
        }
    }
    
    // set observer
    func set_observer(){
        let root = Database.database().reference()
        // Set an observer for keeping track if new URL is added, then rebuild view.
        root.observe(DataEventType.childAdded, with: { (snapshot) in
            // clear the local video_list
//            if !video_list.isEmpty{ video_list.removeAll() }
//            let urls = snapshot.childSnapshot(forPath: "urls").value as? [String: [String: AnyObject]] ?? [:]
//            for video in urls{
//                // get like for current video if there is a like key
//                let like = snapshot.childSnapshot(forPath: "urls/\(video.key)/like").value as? [String:Int] ?? [:]
//                video_list.append(Video(id: video.key, name: video.value["name"]! as! String, url: video.value["url"]! as! String, like: like.count))
//            }
//            // sorting the video list.
//            let seen = snapshot.childSnapshot(forPath: "seen/hli12314").value as? [String: AnyObject] ?? [:]
//            var seen_list:[String] = []
//            for seen_vid in seen{ seen_list.append(seen_vid.key) }
//            sort_video_list(seen_ids: seen_list)
            retrieve_url_info()
        })
    }
    
    //
    func sort_video_list(seen_ids:[String]){
        // sort video by like number
        video_list.sort{ $0.like > $1.like }
        // remove current video, insert to the first.
        if self.curr_video.name != "cover"{
            self.curr_idx = 0 // Update current index to the first of the list
            for idx in 0..<video_list.count{
                if video_list[idx].name == self.curr_video.name{
                    let elem:Video = video_list.remove(at: idx)
                    video_list.insert(elem, at: 0)
                    break
                }
            }
        }
        // putting all seen video to the end of video_list
        var seen_list:[Video] = []
        // add seen video to seen_list
        for video in video_list{
            if seen_ids.contains(video.id){ seen_list.append(video) }
        }
        
        // remove all seen video from list, append then at the end of the list
        video_list.removeAll(where: {seen_ids.contains($0.id)})
        for video in video_list{
            print(video.name)
        }
        print("videos after adding seens")
        // append all in-ordered seen video after video list
        video_list.append(contentsOf: seen_list)
        
        for video in video_list{
            print(video.name)
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
