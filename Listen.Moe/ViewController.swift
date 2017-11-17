//
//  ViewController.swift
//  Listen.Moe
//
//  Copyright © 2017 Disre. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Starscream

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

class ViewController: UIViewController {
    
    var socket = WebSocket(url: URL(string: "wss://listen.moe/api/v2/socket")!)
    var player = AVPlayer()
    var playing:Bool = false
    
    @IBOutlet var SongTitle: UILabel!
    @IBOutlet var Artist: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    
    @IBAction func playAudio(_ sender: Any) {
        if (playing){
            player.pause()
            playing = false
            playBtn.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
        }
        else{
            player.play()
            playing = true
            playBtn.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//         Do any additional setup after loading the view, typically from a nib.
        socket.delegate = self
        socket.connect()
        prepareAudio()
        getData()
        UIApplication.shared.statusBarStyle = .lightContent
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 255/255, green: 27/255, blue: 38/255, alpha: 1.0)
    }
    
    deinit {
        socket.disconnect(forceTimeout: 0)
        socket.delegate = nil
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareAudio(){
        super.viewDidLoad()
        //         Do any additional setup after loading the view, typically from a nib.
        guard let url = URL(string:"https://listen.moe/fallback") else {
            return
        }
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem:playerItem)
        player.rate = 1.0
        player.pause()
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
            try session.setActive(true)
        } catch let error as NSError{
            print("Unable to activate audio session:  \(error.localizedDescription)")
        }
    }
    
    func getData(){
//        let jsonURL = "https://listen.moe/api/v2/socket"
//        guard let url = URL(string: jsonURL) else
//            {return}
//
//        URLSession.shared.dataTask(with: url) { (data, response, err) in
//
//            guard let data = data else {return}
//
//            do {
//                let base = try JSONDecoder().decode(Base.self, from: data)
//                print(base)
//            } catch let jsonError {
//                print("JSON Error: ", jsonError)
//            }
//        }.resume()
    }
}

extension ViewController : WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocket is disconnected: \(String(describing: error?.localizedDescription))")
        socket.connect()
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        do {
            //for some reason cant decode arrays sees them as dictionarys
            let base = try JSONDecoder().decode(Base.self, from: text.data(using: .utf8)!)
//            print(base)
            SongTitle.text = base.song_name
            Artist.text = base.artist_name
        } catch let jsonError {
//            print(text)
//            print("JSON Error: ", jsonError)
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
//        do {
//            let base = try JSONDecoder().decode(Base.self, from: data)
//            print(base)
//        } catch let jsonError {
//            print("JSON Error: ", jsonError)
//        }
    }
    
    func prefersStatusBarHidden() -> Bool {
        return true
    }
}
