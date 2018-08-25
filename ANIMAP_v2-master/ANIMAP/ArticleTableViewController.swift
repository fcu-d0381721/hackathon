//
//  ArticleTableViewController.swift
//  ANIMAP
//
//  Created by 謝忠穎 on 2017/7/7.
//  Copyright © 2017年 Winky_swl. All rights reserved.
//

import UIKit
import Firebase

class ArticleTableViewController: UITableViewController {

    var ref = DatabaseReference()
    
    var commentList = [Comments]()
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headertitle: UILabel!
    @IBOutlet weak var headerbody: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var like: UILabel!
    @IBOutlet weak var floor: UILabel!
    @IBOutlet weak var likebutton: UIButton!
    @IBOutlet weak var articleUserName: UILabel!
 
    var article = Articles()
    
    var id: String = ""
    
    var likeRef = DatabaseReference()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundView?.backgroundColor = UIColor(colorLiteralRed: 255, green: 255, blue: 255, alpha: 0)
        
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        footer.backgroundColor = UIColor(white: 0, alpha: 0)

        
        tableView.tableFooterView = footer
        
        tableView.separatorStyle = .none
        
        self.date.text = String(article.time as! String)
        self.like.text = String(article.like as! Int)
        articleUserName.text = "- " + article.userName!
        
        getComment()
        
//        let currentDateTime = Date()
//        let formatter = DateFormatter()
//        formatter.timeStyle = .none
//        formatter.dateStyle = .long
//        formatter.string(from: currentDateTime)
//        
//        print("-----\(formatter.string(from: currentDateTime))")
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        headertitle.backgroundColor = UIColor(white: 0, alpha: 0)
        headerbody.backgroundColor = UIColor(white: 0, alpha: 0)

        
        
        headertitle.text = article.title
        headerbody.text = article.body
        
        let size = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        headerView.frame.size = size
        tableView.tableHeaderView = headerView
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return commentList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custCell", for: indexPath) as! ArticleViewTableViewCell
         cell.bodylabel.text = commentList[indexPath.row].body
        cell.floor.text = "B\(indexPath.row + 1)"
        print("B\(indexPath.row + 1)")
         //cell.textLabel?.text = a[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }

    @IBAction func likeButton(_ sender: UIButton) {
        
        ref = Database.database().reference().child("articles").child(article.id!)
        
        var like = Int(article.like!)
        like = like + 1
        
        var likeHash = ["like": "\(like)"] as [String : Any]
        ref.updateChildValues(likeHash)
        self.like.text = "\(like)"
        if likebutton.imageView != UIImage(named: "like"){
            addTotalLike()
        }
        likebutton.setImage(UIImage(named: "like"), for: .normal)
        
    }
    
    func addTotalLike(){
        likeRef = Database.database().reference().child("users").child(self.article.userid!).child("totalLike")
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print(snapshot.value)
            if let totalLike = snapshot.value as? String {
                //Do not cast print it directly may be score is Int not string
                print(totalLike)
                var totalLikeTemp = Int(totalLike)!
                totalLikeTemp += 1
                
                let totalLikeObject = ["totalLike": String(totalLikeTemp)] as [String : Any]
                
                self.likeRef = Database.database().reference().child("users").child(self.article.userid!)
                self.likeRef.updateChildValues(totalLikeObject)
            }else{
                print("NOOO")
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getComment(){
        ref = Database.database().reference().child("articles").child(article.id!).child("comments")
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            self.commentList.removeAll()
            
            //iterating through all the values
            for commentData in snapshot.children.allObjects as! [DataSnapshot] {
                //getting values
                let commentObject = commentData.value as? [String: AnyObject]
                
                let commentTemp = Comments()
                commentTemp.id = commentData.key
                commentTemp.body = commentObject?["body"] as? String
                commentTemp.name = commentObject?["name"] as? String
                
                self.commentList.append(commentTemp)
            }
            self.tableView.reloadData()
        })
        
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
