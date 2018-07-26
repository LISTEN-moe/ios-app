//
//  RegisterViewController.swift
//  Listen.Moe
//
//  Copyright © 2017 Disre. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBAction func registerBtn(_ sender: Any) {
//        if username.text != "" && password.text != "" && email.text != ""{
//            register(username: username.text!, password: password.text!, email:email.text!)
//        } else {
//            errorMsg.text = "You didn't enter enough stuff..."
//            errorMsg.isHidden = false
//        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.errorMsg.isHidden = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor(red: 234/255, green: 33/255, blue: 88/255, alpha: 1.0)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        username.delegate = self
        password.delegate = self
        email.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func register(username:String, password:String, email:String){
//
//        var request = URLRequest(url: URL(string: "https://listen.moe/api/register")!)
//        request.httpMethod = "POST"
//        let postString = "username=\(username)&email=\(email)&password=\(password)"
//        request.httpBody = postString.data(using: .utf8)
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {                                                 // check for fundamental networking error
//                print(error?.localizedDescription as Any)
//                return
//            }
//
//            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
////                print("response = \(response)")
//
//            }
//
////            let responseString = String(data: data, encoding: .utf8)
////            print("responseString = \(responseString)")
//
//            let info = try? JSONDecoder().decode(Response.self, from: data)
////            if info?.success == true {
//                self.errorMsg.text = "Please check your Email"
//                self.errorMsg.isHidden = false;
////            } else {
//                DispatchQueue.main.async() { () -> Void in
//                    let error = info?.message!
//                    self.errorMsg.text = "Oops something went wrong..."
//                    self.errorMsg.isHidden = false;
//                    let alert = UIAlertController(title: "Oops", message: error, preferredStyle: UIAlertControllerStyle.alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
////                }
//            }
//        }
//        task.resume()
//
//    }
    
    func goAwayLogin () {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
