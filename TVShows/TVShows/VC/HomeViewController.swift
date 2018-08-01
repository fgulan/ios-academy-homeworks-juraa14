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
        homeTableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc private func _logoutActionHandler() {
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "password")
        navigationController?.popViewController(animated: true)
    }
    

    private func APICall() {
        SVProgressHUD.show()
        
        let token: String = (loginUser?.token)!
        
        let headers = ["Authorization": token]
        Alamofire
            .request("https://api.infinum.academy/api/shows",
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self]
                (response: DataResponse<[Show]>)  in
                
                guard let `self` = self else { return }
                
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let shows):
                    self.listOfShows = shows
                    self.homeTableView.reloadData()
                case .failure(let error):
                    print(error)
                }
        }
    }
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeViewControllerCell",
                                                 for: indexPath) as! HomeViewControllerCell
        
        let item = HomeViewCellItem(
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
        showDetailsViewController.setupWith(token: (loginUser?.token)!, showId: listOfShows[indexPath.row].id)
        self.navigationController?.pushViewController(showDetailsViewController, animated: true)
        
       // print(listOfShows[indexPath.row], loginUser!)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension HomeViewController: UITableViewDelegate{
    
}
