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
import Kingfisher

class HomeViewController: UIViewController {

    var loginUser: LoginData?
    private var listOfShows = [Show]()
    
    
    @IBOutlet weak var homeTableView: UITableView!{
        didSet {
            homeTableView.dataSource = self
            homeTableView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Shows"
        
        navigationItem.setHidesBackButton(true, animated: true)
        
        let logoutItem = UIBarButtonItem.init(image: UIImage(named: "ic-logout"),
                                              style: .plain,
                                              target: self,
                                              action:
            #selector(_logoutActionHandler))
        navigationItem.leftBarButtonItem = logoutItem
        
        APICall()
        //print(listOfShows.count)
        homeTableView.reloadData()
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc private func _logoutActionHandler() {
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "password")
        navigationController?.popViewController(animated: true)
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
                (response: DataResponse<[Show]>)  in
                
                SVProgressHUD.dismiss()
            { [weak self] in
                switch response.result {
                case .success(let shows):
                    self?.listOfShows = shows
                    self?.homeTableView.reloadData()
                    //print(self.listOfShows.count)
                case .failure(let error):
                    print(error)
                }
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
        let imageUrl = listOfShows[row].imageUrl
        let url = URL(string: "https://api.infinum.academy" + imageUrl)
        cell.showImage.kf.setImage(with: url)
        cell.configureCell(with: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let showDetailsViewController: ShowDetailsViewController = storyboard.instantiateViewController(withIdentifier: "ShowDetailsViewController") as! ShowDetailsViewController
        showDetailsViewController.showID = listOfShows[indexPath.row].id
        showDetailsViewController.token = (loginUser?.token)!
        self.navigationController?.pushViewController(showDetailsViewController, animated: true)
        
       // print(listOfShows[indexPath.row], loginUser!)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension HomeViewController: UITableViewDelegate{
    
}
