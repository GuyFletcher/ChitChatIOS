//
//  PostTableViewController.swift
//  ChitChat
//
//  Created by Hart, Fletcher on 4/5/18.
//  Copyright © 2018 Hart, Fletcher. All rights reserved.
//

import UIKit

extension URLSession {
    //https://stackoverflow.com/questions/26784315/can-i-somehow-do-a-synchronous-http-request-via-nsurlsession-in-swift
    func synchronousDataTask(with url: URL) -> (Data?, URLResponse?, Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let dataTask = self.dataTask(with: url) {
            data = $0
            response = $1
            error = $2
            
            semaphore.signal()
        }
        dataTask.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        return (data, response, error)
    }
}

class PostTableViewController: UITableViewController {
    
    var posts: [Message] = [Message]()
    
    let url = URL(string: "https://www.stepoutnyc.com/chitchat?client=fletcher.hart@mymail.champlain.edu&key=3f163a05-fb2c-411e-a6cf-a193e68d8fcb")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPosts()
        

    }
    //likeing a post
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let postURL = URL(string: "https://www.stepoutnyc.com/chitchat/like/" + self.posts[editActionsForRowAt.row].id! + "?client=fletcher.hart@mymail.champlain.edu&key=3f163a05-fb2c-411e-a6cf-a193e68d8fcb")
        
        let like = UITableViewRowAction(style: .normal, title: "Like") { action, index in
            
            (data, response, error) = URLSession.shared.synchronousDataTask(with: postURL!)
            
            
        }
        like.backgroundColor = .green
        
        let dislike = UITableViewRowAction(style: .normal, title: "Dislike") { action, index in
            
            
            print(self.posts[index.row].message!)
            
        }
        dislike.backgroundColor = .red
        
        return [dislike, like]
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //Fetching posts
    func fetchPosts() {
        
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        (data, response, error) = URLSession.shared.synchronousDataTask(with: url)
        if let error = error {
            print(error.localizedDescription)
        }
            
            if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let data = data {
                        let jsonObject = try! JSONSerialization.jsonObject(with: data)
                        if let jsonObject = jsonObject as? [String: Any], let messages = jsonObject["messages"] as? [[String: Any]] {
                            for message in messages {
                                if let client = message["client"] as? String, let postID = message["_id"], let like = message["likes"], let dislike = message["dislikes"], let latLong = message["loc"], let message = message["message"]
                                {
                                    //print("\(client): \(message)")
                                    let m: Message = Message()
                                    m.client = client
                                    m.message = message as? String
                                    m.like = like as? Int
                                    m.dislike = dislike as? Int
                                    m.id = postID as? String
                                    //m.long = latLong[1] as? String
                                    //m.lat = latLong[0] as? String
                                    
                                    self.posts.append(m)
                                }
                            }
                            
                        }
                        
                    }
                    
                }
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Posts", posts.count)
        return posts.count
    }
    
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let postInfo = posts[indexPath.row]
        cell.textLabel?.text = postInfo.message! + "Likes: " + String(describing: postInfo.like)

        return cell
    }    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
