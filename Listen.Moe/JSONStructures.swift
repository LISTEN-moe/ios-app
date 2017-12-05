//
//  JSONStructures.swift
//  Listen.Moe
//
//  Created by Kelson Vella on 12/4/17.
//  Copyright © 2017 Disre. All rights reserved.
//

import Foundation

struct section {
    var name:String
    var songList:[song]
}

struct favorite: Codable {
    var success:Bool
    var songs:[song]?
    var extra:extra?
}

struct song: Codable {
    var id:Int
    var artist:String
    var title:String
    var anime:String?
    var enabled:Bool?
    var titleFirstLetter:String{
        if self.title != "" {
            let str = String(self.title[self.title.startIndex]).uppercased().unicodeScalars.first
            let alpha = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
            let digits = CharacterSet.decimalDigits
            if digits.contains(str!) {
                return "1"
            }
            else if alpha.contains(str!) {
                return String(self.title[self.title.startIndex]).uppercased()
            } else {
                return "*"
            }
        } else {
            return ""
        }
    }
    //    var artistFirstLetter:String{
    //        return String(self.artist[self.artist.startIndex]).uppercased()
    //    }
}

struct extra:Codable {
    var requests:Int
}

struct unfavorite: Codable {
    var success:Bool
    var favorite:Bool
}

struct songRequest: Codable {
    var success:Bool
}

struct Response: Codable {
    var success: Bool
    var token: String?
    var message: String?
}

struct Base: Decodable {
    let song_id: Int?
    let artist_name: String?
    let song_name: String?
    let anime_name: String?
    let requested_by: String?
    let listeners: Int?
    //not working for some reason
    //let last: [Last]
    //let second_last: [Second]
    //let extended: [Extended]
}

struct Last: Decodable {
    let song_name: String?
    let artist_name: String?
}

struct Second: Decodable {
    let song_name: String?
    let artist_name: String?
}

struct Extended: Decodable {
    let favorite: Bool?
    let queue: [Queue]
}

struct Queue: Decodable {
    let songsInQueue: Int?
    let hasSongInQueue: Bool?
    let inQueueBeforeUserSong: Int?
    let userSongsInQueue: Int?
}

struct user: Decodable {
    let success: Bool
    let id: Int
    let username: String
}
