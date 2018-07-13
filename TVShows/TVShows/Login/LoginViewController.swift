//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 06/07/2018.
//  Copyright © 2018 Juraj Radanovic. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Private -
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    var checked = UIImage(named: "ic-checkbox-filled")
    var unchecked = UIImage(named: "ic-checkbox-empty")
    
    var isCheckBoxClicked:Bool!
    
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
