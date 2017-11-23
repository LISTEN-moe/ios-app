//
//  SongsViewController.swift
//  Listen.Moe
//
//  Created by Kelson Vella on 11/21/17.
//  Copyright © 2017 Disre. All rights reserved.
//

import UIKit

class SongsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var songs:[song] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = songs[indexPath.row]
        cell.textLabel?.text = song.title
        cell.detailTextLabel?.text = song.artist
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Request"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor(red: 234/255, green: 33/255, blue: 88/255, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor(red: 234/255, green: 33/255, blue: 88/255, alpha: 1.0)]
        getSongs()
    }
    
    func getSongs(){
        let userDefaults = UserDefaults.standard
//        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTEsInVzZXJuYW1lIjoiQ292ZSIsImlhdCI6MTUxMDk3MzMwNywiZXhwIjoxNTEzNTY1MzA3fQ.eKSgw5MntMJFFVOX99L-Wh6lbNphrUyICqYzKb3fros"
        if let token = userDefaults.object(forKey: "token") as? String {
            var request = URLRequest(url: (URL(string: "https://listen.moe/api/songs?token=\(token)"))!)
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
                //            let responseString = String(data: data, encoding: .utf8)
                //            print("responseString = \(responseString)")
                let base = try? JSONDecoder().decode(favorite.self, from:data)
                if (base?.success)! {
                    self.songs = (base?.songs)!.sorted(by: {$0.title < $1.title})
                    DispatchQueue.main.async() { () -> Void in
    //                    if self.songs.count == 0 {
    //
    //                        let alert = UIAlertController(title: "Oh", message: "You have no favorites yet", preferredStyle: UIAlertControllerStyle.alert)
    //                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    //                        self.present(alert, animated: true, completion: nil)
    //                    }
                        self.tableView.reloadData()
                    }
                }
            }
            task.resume()
            }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
