//
//  addEpViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 24/07/2018.
//  Copyright © 2018 Juraj Radanovic. All rights reserved.
//

import UIKit

class addEpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
        print("hi")
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
