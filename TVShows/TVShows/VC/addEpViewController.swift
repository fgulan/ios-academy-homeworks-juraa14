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

class addEpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var token: String?
    var showID: String?
    
    private var pickedImage: UIImage?
    
    let imagePicker = UIImagePickerController()
    
    weak var delegate: EpisodeAddedDelegate?
    
    @IBOutlet weak var episodeImage: UIImageView!
    @IBOutlet weak var epTitleTextField: UITextField!
    @IBOutlet weak var epNumberTextField: UITextField!
    @IBOutlet weak var seasonNumberTextField: UITextField!
    @IBOutlet weak var epDescriptionTextField: UITextField!
    
    @IBAction func uploadImageButtonTapped(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
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
            if pickedImage == nil{
                createEpisodeAPICall(mediaId: "")
            } else {
                uploadImageOnAPI()
            }
        }
    }
    
    func uploadImageOnAPI() {
        
        let token = self.token!
        
        let headers = ["Authorization": token]
        //let someUIImage = UIImage(named: "splash-logo")!
        let imageByteData = UIImagePNGRepresentation(episodeImage.image!)!
        Alamofire
            .upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageByteData,
                                         withName: "file",
                                         fileName: "image.png",
                                         mimeType: "image/png")
            }, to: "https://api.infinum.academy/api/media",
               method: .post,
               headers: headers)
            { [weak self] result in
                switch result {
                case .success(let uploadRequest, _, _):
                    print("DONE WITH UPLOAD REQUEST \(uploadRequest)")
                    self?.processUploadRequest(uploadRequest)
                case .failure(let encodingError):
                    print(encodingError)
                } }
    }
                                         
    
    func processUploadRequest(_ uploadRequest: UploadRequest) {
        uploadRequest
            .responseDecodableObject(keyPath: "data") { (response:
                DataResponse<Media>) in
                    switch response.result {
                        case .success(let media):
                            print("DECODED: \(media)")
                            print("Proceed to add episode call...")
                            self.createEpisodeAPICall(mediaId: media.id)
                        case .failure(let error):
                            print("FAILURE: \(error)")
                }
        }
    }

    
    func createEpisodeAPICall(mediaId: String){
        SVProgressHUD.show()
        
        guard
            let showID = showID,
            let title = epTitleTextField.text,
            let description = epDescriptionTextField.text
        else {
            return
        }
        
        let parameters: [String: String] = [
            "showId" : showID,
            "mediaId" : mediaId,
            "title" : title,
            "description" : description,
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
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self]
                (response: DataResponse<newEpisode>) in
                
                guard let `self` = self else { return }
                
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let newEp):
                    //print(newEp)
                    print("EPISODE CREATED \(newEp)")
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

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            episodeImage.contentMode = UIViewContentMode.scaleAspectFit
            episodeImage.image = pickedImage
            self.pickedImage = pickedImage
        }
    }
    
}
