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
    var numberOfTaps: Int = 0
    var countDownTimer: Timer!
    var seconds = 3
    
    @IBOutlet var LabelOutlet: UILabel!
    @IBOutlet var ActivityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ActivityIndicatorView.startAnimating()
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func updateTime(){
        if seconds != 0 {
            seconds -= 1
        }
        else{
            self.ActivityIndicatorView.stopAnimating()
            countDownTimer.invalidate()
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
    @IBAction func TapButtonAction(_ sender: Any) {
        numberOfTaps += 1
        self.LabelOutlet.text = String(numberOfTaps)
        if self.ActivityIndicatorView.isAnimating {
            self.ActivityIndicatorView.stopAnimating()
        }
        else{
            self.ActivityIndicatorView.startAnimating()
        }
    }
    
    
    
    
}
