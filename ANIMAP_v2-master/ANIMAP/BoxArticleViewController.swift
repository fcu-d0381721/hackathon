//
//  BoxArticleViewController.swift
//  ANIMAP
//
//  Created by 謝忠穎 on 2017/7/8.
//  Copyright © 2017年 Winky_swl. All rights reserved.
//

import UIKit
import Firebase

class BoxArticleViewController: UIViewController {

    var ref: DatabaseReference!
    var answerRef: DatabaseReference!
    
    var artcle = Articles()

    @IBOutlet weak var subArea: UILabel!
    @IBOutlet weak var cardview: UIView!
    @IBOutlet weak var articleView: UIView!
    @IBOutlet weak var inputboxBottom: NSLayoutConstraint!
    @IBOutlet weak var articleview: UIView!
    
     var textFiled = UITextField()
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        taptocloseKeyboard()
        
        textFiled = UITextField(frame: CGRect(x: 18 , y: 10, width: UIScreen.main.bounds.width - 100, height: 33))
        textFiled.backgroundColor = UIColor(white: 0, alpha: 0)
        textFiled.borderStyle = UITextBorderStyle.none
        textFiled.placeholder = "回應一下吧．．．"
        self.cardview.addSubview(textFiled)
        
        
        
        let point = cardview.center
        let center_x = floor(point.x);
        let center_y = floor(point.y);
        cardview.center = CGPoint(x: center_x, y: center_y)
        
        
        

    
        
        //cardview.backgroundColor = UIColor(white: 1, alpha: 1)
        cardview.layer.shadowColor = UIColor.black.cgColor
        cardview.layer.shadowOpacity = 0.3
        cardview.layer.shadowOffset = CGSize(width: 2, height: -2)
        cardview.layer.shadowRadius = 3
//        cardview.layer.shouldRasterize = true
        

        
        subArea.text = artcle.subArea
        
        

        
//        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(BoxArticleViewController.cancelview))
//        edgePan.edges = .left
//        view.addGestureRecognizer(edgePan)
        
    }
    
    func cancelview(){
        self.dismiss(animated: false, completion: nil)
    }
    
    func taptocloseKeyboard(){
        articleview.isUserInteractionEnabled = true
        let singleFinger =
            UITapGestureRecognizer(target: self, action: #selector(singleTap(recognizer:)))
        singleFinger.numberOfTapsRequired = 1
        singleFinger.numberOfTouchesRequired = 1
        articleview.addGestureRecognizer(singleFinger)
    }
    
    func singleTap(recognizer:UITapGestureRecognizer){
        //print("單指連點一下")

        textFiled.endEditing(true)
        inputboxBottom.constant = 0
    }

    
    
    func handleNotification(notification: NSNotification){
        if let userinfo = notification.userInfo{
            let keyboardHeight = (userinfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
            print(keyboardHeight)
            
            inputboxBottom.constant = keyboardHeight
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "article")
        {
            let vc: ArticleTableViewController = segue.destination as! ArticleTableViewController
            vc.article = self.artcle
        }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

    @IBAction func sendtext(_ sender: Any) {
        textFiled.resignFirstResponder()
        inputboxBottom.constant = 0
        print(textFiled.text ?? String())
        addComment(body: textFiled.text ?? String())
        textFiled.text = ""
    }
    
    func addComment(body: String) {
        
        if(body == ""){
            return
        }
        
        ref = Database.database().reference().child("articles").child(artcle.id!).child("comments")
        let comment = ["body": body,
                        "name": "name"
            ] as [String : Any]
        
        let someDate = Date()
        let timeInterval = someDate.timeIntervalSince1970
        
        ref.child("c\(Int(timeInterval*100000))").setValue(comment)
        addTotalLike()
    }
    
    func addTotalLike(){
        answerRef = Database.database().reference().child("users").child(ShareManager.sharedInstance.uid!).child("totalAnswer")
        answerRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if let totalAnswer = snapshot.value as? String {
                //Do not cast print it directly may be score is Int not string
                print(totalAnswer)
                var totalAnswerTemp = Int(totalAnswer)!
                totalAnswerTemp += 1
                
                let totalAnswerObject = ["totalAnswer": String(totalAnswerTemp)] as [String : Any]
                
                self.answerRef = Database.database().reference().child("users").child(ShareManager.sharedInstance.uid!)
                self.answerRef.updateChildValues(totalAnswerObject)
            }else{
                print("NOOO")
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
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
