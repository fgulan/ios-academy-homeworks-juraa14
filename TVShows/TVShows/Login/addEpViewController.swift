//
//  addEpViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 24/07/2018.
//  Copyright © 2018 Juraj Radanovic. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import SVProgressHUD

protocol EpisodeAddedDelegate: class {
    func didAddEpisode(title: String)
}

class addEpViewController: UIViewController {

    var token: String?
    var showID: String?
    
    weak var delegate: EpisodeAddedDelegate?
    
    @IBOutlet weak var epTitleTextField: UITextField!
    @IBOutlet weak var epNumberTextField: UITextField!
    @IBOutlet weak var seasonNumberTextField: UITextField!
    @IBOutlet weak var epDescriptionTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        epTitleTextField.setBottomBorder()
        epNumberTextField.setBottomBorder()
        seasonNumberTextField.setBottomBorder()
        epDescriptionTextField.setBottomBorder()
        
        navigationItem.title = "Add episode"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didSelectCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Add",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didSelectAdd))
        // Do any additional setup after loading the view.
    }
    
    @objc func didSelectAdd(){
        if !(epTitleTextField.text?.isEmpty)!, !(epNumberTextField.text?.isEmpty)!, !(epDescriptionTextField.text?.isEmpty)!,
            !(seasonNumberTextField.text?.isEmpty)!{
            createEpisodeAPICall()
        }
    }
    
    func createEpisodeAPICall(){
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "showId" : showID!,
            "mediaId" : "",
            "title" : epTitleTextField.text!,
            "description" : epDescriptionTextField.text!,
            "episodeNumber" : epNumberTextField.text!,
            "season" : seasonNumberTextField.text!
        ]
        let token = (self.token)!
        
        let headers = ["Authorization": token]
        
        Alamofire
            .request("https://api.infinum.academy/api/episodes",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                (response: DataResponse<newEpisode>) in
                
                
                SVProgressHUD.dismiss()
                
                switch response.result {
                case .success(let newEp):
                    print(newEp)
                    self.delegate?.didAddEpisode(title: newEp.title)
                    self.dismiss(animated: true, completion: nil)
                case .failure(let error):
                    print(error)
                    let alertController = UIAlertController(title:"Error adding episode", message: error as? String, preferredStyle: .alert)
                    self.present(alertController, animated: true, completion: nil)
                }
        }
    }
    
    @objc func didSelectCancel() {
        dismiss(animated: true, completion: nil)
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
