//
//  CommentViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 30/07/2018.
//  Copyright © 2018 Juraj Radanovic. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import SVProgressHUD

class CommentViewController: UIViewController {

    var episodeId: String = ""
    var token: String?
    private var comments = [Comment]()
    private var userImages: [UIImage] = [
        UIImage(named: "img-placeholder-user1")!,
        UIImage(named: "img-placeholder-user2")!,
        UIImage(named: "img-placeholder-user3")!
    ]
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var commentContainerView: UIView!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func postButtonPressed(_ sender: Any) {
        if !(commentTextField.text?.isEmpty)! {
            postCommentAPICall()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCommentsAPICall()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotificationShow), name: NSNotification.Name.UIKeyboardWillShow , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotificationHide), name: NSNotification.Name.UIKeyboardWillHide , object: nil)
        // Do any additional setup after loading the view.
    }

    @objc func handleKeyboardNotificationShow(notification: NSNotification) {
        
        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            if self.commentContainerView.frame.origin.y == 0 {
                self.commentContainerView.frame.origin.y -= (keyboardHeight * 1.2)
            }
        }
    }
    
    @objc func handleKeyboardNotificationHide(notification: NSNotification) {
        
        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            if self.commentContainerView.frame.origin.y != 0 {
                self.commentContainerView.frame.origin.y += keyboardHeight
            }
        }
    }
    
    private func getCommentsAPICall() {
        SVProgressHUD.show()
        
        let token: String = (self.token)!
        
        let headers = ["Authorization": token]
        Alamofire
            .request("https://api.infinum.academy/api/episodes/\(String(describing: episodeId))/comments",
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                (response: DataResponse<[Comment]>)  in
                
                SVProgressHUD.dismiss()
                    { [weak self] in
                        switch response.result {
                        case .success(let comments):
                            self?.comments = comments
                            self?.tableView.reloadData()
                        case .failure(let error):
                            print(error)
                        }
                }
        }
        
        // print(listOfShows.count)
    }
    
    private func postCommentAPICall() {
        SVProgressHUD.show()
        
        let token: String = (self.token)!
        
        let parameters: [String: String] = [
            "text" : commentTextField.text!,
            "episodeId" : episodeId
        ]
        
        let headers = ["Authorization": token]
        Alamofire
            .request("https://api.infinum.academy/api/comments",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                (response: DataResponse<Comment>)  in
                
                SVProgressHUD.dismiss()
                
                        switch response.result {
                        case .success(let comment):
                            print(comment)
                        case .failure(let error):
                            print(error)
                        }
                
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

extension CommentViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comments.count > 0 {
            return comments.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        let cell: CommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell",
                                                                       for: indexPath) as! CommentTableViewCell
        
        let item: commentCellItems = commentCellItems (
            id: nil,
            text: comments[row].text,
            userEmail: comments[row].userEmail,
            image: userImages[row % 3]
        )
        
        cell.configureCell(with: item)
        
        return cell
    }
}

extension CommentViewController: UITableViewDelegate {
    
}
