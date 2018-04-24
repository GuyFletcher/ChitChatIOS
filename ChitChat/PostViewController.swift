//
//  PostViewController.swift
//  ChitChat
//
//  Created by Hart, Fletcher on 4/24/18.
//  Copyright © 2018 Hart, Fletcher. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    @IBOutlet weak var mesText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postMes(_ sender: UIButton) {
        
        let postURL = URL(string: "https://www.stepoutnyc.com/chitchat?client=fletcher.hart@mymail.champlain.edu&key=3f163a05-fb2c-411e-a6cf-a193e68d8fcb")
        
        var request = URLRequest(url: postURL!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "message=" + mesText.text!
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
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
