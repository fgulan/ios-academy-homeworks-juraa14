//
//  HomeViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 16/07/2018.
//  Copyright © 2018 Juraj Radanovic. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

class HomeViewController: UIViewController {

    var loginUser: LoginData?
    private var listOfShows = [Show]()
    
    
    @IBOutlet weak var homeTableView: UITableView!{
        didSet{
            homeTableView.dataSource = self
            homeTableView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Shows"
        
        APICall()
        //print(listOfShows.count)
        homeTableView.reloadData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    fileprivate func APICall() {
        SVProgressHUD.show()
        
        let token: String = (loginUser?.token)!
        
        let headers = ["Authorization": token]
        Alamofire
            .request("https://api.infinum.academy/api/shows",
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                (response: DataResponse<[Show]>) in
                
                SVProgressHUD.dismiss()
                
                switch response.result {
                case .success(let shows):
                    self.listOfShows = shows
                    self.homeTableView.reloadData()
                    //print(self.listOfShows.count)
                case .failure(let error):
                    print(error)
                }
        }
        
       // print(listOfShows.count)
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

extension HomeViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(listOfShows.count)
        
        return listOfShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        let cell: HomeViewControllerCell = tableView.dequeueReusableCell(withIdentifier: "HomeViewControllerCell",
                                                                         for: indexPath) as! HomeViewControllerCell
        
        let item: HomeViewCellItem = HomeViewCellItem(
            title: listOfShows[row].title
        )
        
        cell.configureCell(with: item)
        
        return cell
    }
    
}

extension HomeViewController: UITableViewDelegate{
    
}
