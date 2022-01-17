//
//  Video.swift
//  openTok
//
//  Created by HLi on 4/30/21.
//

import Foundation
import Firebase

class Video{
    var id:String
    var name:String
    var url:String
    var like:Int // Not sure if I should have this
    
    init(id:String, name:String, url:String, like:Int){
        self.id = id
        self.name = name
        self.url = url
        self.like = like
    }
}
