//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 06/07/2018.
//  Copyright © 2018 Juraj Radanovic. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import CodableAlamofire


class LoginViewController: UIViewController {
    
    // MARK: - Private -
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    var checked = UIImage(named: "ic-checkbox-filled")
    var unchecked = UIImage(named: "ic-checkbox-empty")
    
    var isCheckBoxClicked:Bool!
    
    private var user: User? = nil
    private var loginToken: LoginData? = nil
    
    struct User: Codable {
        let email: String
        let type: String
        let id: String
        enum CodingKeys: String, CodingKey {
            case email
            case type
            case id = "_id"
        }
    }
    struct LoginData: Codable {
        let token: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        usernameTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
        checkBox.setImage(unchecked, for: UIControlState.normal)
        loginButton.roundedButton()
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
    
    @IBAction func CheckBoxImageChange(_ sender: Any) {
        
        if isCheckBoxClicked == true{
            isCheckBoxClicked = false
            checkBox.setImage(unchecked, for: UIControlState.normal)
        }
        else{
            isCheckBoxClicked = true
            checkBox.setImage(checked, for: UIControlState.normal)
        }
    }
    
    @IBAction func LoginButtonAction(_ sender: Any) {
        if let email = usernameTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty{
            LoginAPICall(email: email, password: password)
        }
        
        //let storyboard = UIStoryboard(name: "Login", bundle: nil)
        //let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        //navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    
    @IBAction func CreateAccountButtonAction(_ sender: Any) {
        
        if let email = usernameTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty {
            
            SVProgressHUD.show()
            
            let parameters: [String: String] = [
                "email": email,
                "password": password
            ]
            Alamofire
                .request("https://api.infinum.academy/api/users",
                         method: .post,
                         parameters: parameters,
                         encoding: JSONEncoding.default)
                .validate()
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                    (response: DataResponse<User>) in
            
            
                        SVProgressHUD.dismiss()
            
                        switch response.result {
                            case .success(let user):
                                    self.user = user
                                    self.LoginAPICall(email: email, password: password)
                            case .failure(let error):
                                    print("API failure: \(error)")
                        }
            }
        }
        
        
        //let storyboard = UIStoryboard(name: "Login", bundle: nil)
        //let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        //navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    func LoginAPICall(email: String, password: String){
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        Alamofire
            .request("https://api.infinum.academy/api/users/sessions",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                (response: DataResponse<LoginData>) in
               
                SVProgressHUD.dismiss()
                
                switch response.result {
                case .success(let token):
                    self.loginToken = token
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        navigationController?.pushViewController(homeViewController, animated: true)
        
    }
    
}

extension UIButton{
    
    func roundedButton(){
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}

extension UITextField{
    
    func setBottomBorder(){
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}


