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
    
    private var isCheckBoxClicked:Bool!
    
    private var user: User? = nil
    private var loginToken: LoginData? = nil
    
    @IBOutlet var LabelOutlet: UILabel!
    @IBOutlet var ActivityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        usernameTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
        checkBox.setImage(UIImage(named: "ic-checkbox-empty"), for: .normal)
        loginButton.roundedButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        if let username = UserDefaults.standard.object(forKey: "username") as? String, let password = UserDefaults.standard.object(forKey: "password") as? String {
            loginAPICall(email: username, password: password)
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
    
    @IBAction func CheckBoxImageChange(_ sender: Any) {
        
        if isCheckBoxClicked == true{
            isCheckBoxClicked = false
            checkBox.setImage(UIImage(named: "ic-checkbox-empty"), for: .normal)
        }
        else{
            isCheckBoxClicked = true
            checkBox.setImage(UIImage(named: "ic-checkbox-filled"), for: .normal)
        }
    }
    
    @IBAction func LoginButtonAction(_ sender: UIButton) {
        if let email = usernameTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty{
            if isCheckBoxClicked == true {
                UserDefaults.standard.set(email, forKey: "username")
                UserDefaults.standard.set(password, forKey: "password")
            }
            loginAPICall(email: email, password: password)
        } else if (usernameTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            let pulse1 = CASpringAnimation(keyPath: "transform.scale")
            pulse1.duration = 0.6
            pulse1.fromValue = 1.0
            pulse1.toValue = 1.12
            pulse1.autoreverses = true
            pulse1.repeatCount = 1
            pulse1.initialVelocity = 0.5
            pulse1.damping = 0.8
            
            sender.layer.add(pulse1, forKey: nil)
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
                    { [weak self] in
                        switch response.result {
                            case .success(let user):
                                    self?.user = user
                                    self?.loginAPICall(email: email, password: password)
                            case .failure(let error):
                                    print("API failure: \(error)")
                        }
                    }
            }
        }
        
        
        //let storyboard = UIStoryboard(name: "Login", bundle: nil)
        //let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        //navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    func loginAPICall(email: String, password: String){
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
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    let homeViewController: HomeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    self.navigationController?.pushViewController(homeViewController, animated: true)
                    homeViewController.loginUser = self.loginToken
                case .failure(let error):
                    let alertController = UIAlertController(title:"Alert", message: error as? String, preferredStyle: .alert)
                    self.present(alertController, animated: true, completion: nil)
                }
        }
        
        
        
    }
    
}





