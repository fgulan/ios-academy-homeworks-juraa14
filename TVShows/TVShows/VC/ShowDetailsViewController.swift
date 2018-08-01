//
//  ShowDetailsViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 23/07/2018.
//  Copyright © 2018 Juraj Radanovic. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import SVProgressHUD

class ShowDetailsViewController: UIViewController, UITableViewDelegate{

    //MARK: -Properties-
    
    private var token: String!
    private var showID: String!
    
    private var showDetails: ShowDetails?
    private var listOfEpisodes = [Episode]()
    
    private var refreshControl: UIRefreshControl {
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self,
                                 action: #selector(handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        
        return refreshControl
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.refreshControl = refreshControl
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    @IBAction func addShowButton(_ sender: Any) {
        let addEpVC = storyboard?.instantiateViewController(withIdentifier: "addEpViewController") as! addEpViewController
        let navController = UINavigationController(rootViewController: addEpVC)
        addEpVC.delegate = self
        addEpVC.token = self.token
        addEpVC.showID = self.showID
        present(navController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        getDetailsAPICall()
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: -Functions-
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getDetailsAPICall()
        refreshControl.endRefreshing()
    }
    
    func getDetailsAPICall(){
        SVProgressHUD.show()
        guard let token = token, let showId = showID else {return }
        let headers = ["Authorization": token]
        Alamofire
            .request("https://api.infinum.academy/api/shows/\(showId)",
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self]
                (response: DataResponse<ShowDetails>) in
                
                guard let `self` = self else { return }
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let details):
                    self.showDetails = details
                    self.getListOfEpisodesAPICall()
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func setupWith(token: String, showId: String) {
        self.token = token
        self.showID = showId
    }
    
    func getListOfEpisodesAPICall(){
        SVProgressHUD.show()
        
        guard let token = token, let showId = showID else {return }

        let headers = ["Authorization": token]
        Alamofire
            .request("https://api.infinum.academy/api/shows/\(showId)/episodes",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                (response: DataResponse<[Episode]>) in
                
                SVProgressHUD.dismiss()
                
                switch response.result {
                case .success(let episodes):
                    self.listOfEpisodes = episodes
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
        }
    }
}

extension ShowDetailsViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showDetails != nil {
            return 1 + listOfEpisodes.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var row = indexPath.row
        
        if row == 0{
            let cell: DescriptionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DescriptionViewControllerCell",
                                                                             for: indexPath) as! DescriptionTableViewCell
            
            let item: descriptionCellItems = descriptionCellItems(
                imageUrl: showDetails!.imageUrl,
                title: (showDetails!.title) ,
                description: (showDetails!.description),
                numberOfEpisodes: listOfEpisodes.count
            )
            let imageUrl = (showDetails!.imageUrl)
            let url = URL(string: "https://api.infinum.academy" + imageUrl)
            cell.showImage.kf.setImage(with: url)

            cell.configureCell(with: item)
            return cell
        } else{
            row = row - 1
            let cell: EpisodeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EpisodeViewControllerCell",
                                                                           for: indexPath) as! EpisodeTableViewCell
            
            let item: episodeCellItems = episodeCellItems(
                episodeNumber: "S\(listOfEpisodes[row].season) Ep\(listOfEpisodes[row].episodeNumber)",
                episodeName: listOfEpisodes[row].title
            )
            
            cell.configureCell(with: item)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        let row = indexPath.row - 1
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let episodeDetailsViewController: EpisodeDetailsViewController = storyboard.instantiateViewController(withIdentifier: "EpisodeDetailsViewController") as! EpisodeDetailsViewController
        episodeDetailsViewController.imageUrl = listOfEpisodes[row].imageUrl
        episodeDetailsViewController.episodeName = listOfEpisodes[row].title
        episodeDetailsViewController.episodeDescription = listOfEpisodes[row].description
        episodeDetailsViewController.episodeId = listOfEpisodes[row].id
        episodeDetailsViewController.token = self.token
        let episodeNumber = "S\(listOfEpisodes[row].season) Ep\(listOfEpisodes[row].episodeNumber)"
        episodeDetailsViewController.episodeNumber = episodeNumber
        navigationController?.pushViewController(episodeDetailsViewController, animated: true)
    }
    
}

extension ShowDetailsViewController: EpisodeAddedDelegate {
    func didAddEpisode(title: String) {
        tableView.reloadData()
    }
    
    
}
