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
    
    var token: String?
    var showID: String = ""
    private var showDetails: ShowDetails?
    private var listOfEpisodes = [Episode]()
    private var detailedListOfEpisodes = [EpisodeDetails]()
    
    private var refreshControl: UIRefreshControl {
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self,
                                 action: #selector(handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        
        return refreshControl
    }
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
            tableView.addSubview(refreshControl)
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
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.rowHeight = UITableViewAutomaticDimension
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
        
        let token = (self.token)!
        
        let headers = ["Authorization": token]
        Alamofire
            .request("https://api.infinum.academy/api/shows/\(showID)",
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                (response: DataResponse<ShowDetails>) in
                
                SVProgressHUD.dismiss()
                    { [weak self] in
                switch response.result {
                case .success(let details):
                    self?.showDetails = details
                    //print(self.showDetails!)
                    self?.getListOfEpisodesAPICall()
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
                }
        }
    }
    
    func getListOfEpisodesAPICall(){
        SVProgressHUD.show()
        
        let token = (self.token)!
        
        let headers = ["Authorization": token]
        Alamofire
            .request("https://api.infinum.academy/api/shows/\(showID)/episodes",
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
                    //print(self.listOfEpisodes)
                    for i in 0..<self.listOfEpisodes.count{
                        self.getDetailedEpisodesAPICall(episode: self.listOfEpisodes[i])
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func getDetailedEpisodesAPICall(episode: Episode){
        SVProgressHUD.show()
        
        let token = (self.token)!
        
        let headers = ["Authorization": token]
        Alamofire
            .request("https://api.infinum.academy/api/episodes/\(episode.id)",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                (response: DataResponse<EpisodeDetails>) in
                
                SVProgressHUD.dismiss()
                    {[weak self] in
                switch response.result {
                case .success(let episodeDetails):
                    self?.detailedListOfEpisodes.append(episodeDetails)
                    //print(self.detailedListOfEpisodes)
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
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

}

extension ShowDetailsViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showDetails != nil {
            return 1 + detailedListOfEpisodes.count
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
                episodeNumber: "S\(detailedListOfEpisodes[row].season) Ep\(detailedListOfEpisodes[row].episodeNumber)",
                episodeName: detailedListOfEpisodes[row].title
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
        episodeDetailsViewController.imageUrl = detailedListOfEpisodes[row].imageUrl
        episodeDetailsViewController.episodeName = detailedListOfEpisodes[row].title
        episodeDetailsViewController.episodeDescription = detailedListOfEpisodes[row].description
        episodeDetailsViewController.episodeId = detailedListOfEpisodes[row].id
        episodeDetailsViewController.token = self.token
        let episodeNumber = "S\(detailedListOfEpisodes[row].season) Ep\(detailedListOfEpisodes[row].episodeNumber)"
        episodeDetailsViewController.episodeNumber = episodeNumber
        self.navigationController?.pushViewController(episodeDetailsViewController, animated: true)
        
        // print(listOfShows[indexPath.row], loginUser!)
    }
    
}

extension ShowDetailsViewController: EpisodeAddedDelegate {
    func didAddEpisode(title: String) {
        tableView.reloadData()
    }
    
    
}
