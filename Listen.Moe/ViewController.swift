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

struct user: Decodable {
    let success: Bool
    let id: Int
    let username: String
}

class ViewController: UIViewController {
    
    var username:String?
    
    @IBOutlet weak var rightBtn: UIBarButtonItem!
    
    var socket = WebSocket(url: URL(string: "wss://listen.moe/api/v2/socket")!)
    var player = AVPlayer()
    var playing:Bool = false
    
    @IBOutlet var SongTitle: UILabel!
    @IBOutlet var Artist: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var viewFavorites: UIButton!
    @IBOutlet weak var requestBtn: UIButton!
    @IBOutlet weak var favorite: UIButton!
    
    @IBAction func favBtn(_ sender: Any) {
        
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        if self.navigationItem.rightBarButtonItem?.title == "Login" {
            performSegue(withIdentifier: "login", sender: self)
        } else {
            loggedInUI(log: false)
            let userDefaults = UserDefaults.standard
            userDefaults.removeObject(forKey: "token")
        }
    }
    
    
    @IBAction func playAudio(_ sender: Any) {
        if (playing){
            player.pause()
            playing = false
            playBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }
        else{
            player.play()
            playing = true
            playBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
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
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 234/255, green: 33/255, blue: 88/255, alpha: 1.0)
        
        playBtn.layer.cornerRadius = 0.5 * playBtn.bounds.size.width
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let userDefaults = UserDefaults.standard
//        if (userDefaults.object(forKey: "token") as? String) != nil {
//            loggedInUI(log: true)
////            let token = userDefaults.object(forKey: "token") as! String
////            print(token)
//        } else {
//            loggedInUI(log: false)
        stillLoggedIn()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func loggedInUI(log: Bool) {
        viewFavorites.isEnabled = log
        favorite.isEnabled = log
        requestBtn.isEnabled = log
        viewFavorites.isHidden = !log
        favorite.isHidden = !log
        requestBtn.isHidden = !log
        if log == true {
            self.navigationItem.rightBarButtonItem?.title = "Logout"
        } else {
            self.navigationItem.rightBarButtonItem?.title = "Login"
        }
    }
    
    func stillLoggedIn() {
        let userDefaults = UserDefaults.standard
        if let token = userDefaults.object(forKey: "token") as? String {
            var request = URLRequest(url: (URL(string: "https://listen.moe/api/user?token=\(token)"))!)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print(error?.localizedDescription as Any)
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                }
                //
                            let responseString = String(data: data, encoding: .utf8)
                            print("asdasjdnakfjadsfasjbfasjdfas")
                            print("responseString = \(responseString)")
                let base = try? JSONDecoder().decode(user.self, from:data)
                
                DispatchQueue.main.async() { () -> Void in
                    if (base?.success)! {
                            self.loggedInUI(log: true)
                    } else {
                        self.loggedInUI(log: false)
                    }
                }
            }
            task.resume()
        }
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
    
//    func prefersStatusBarHidden() -> Bool {
//        return true
//    }
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
}
