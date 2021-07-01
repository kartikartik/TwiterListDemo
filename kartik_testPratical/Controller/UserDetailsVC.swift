//
//  UserDetailsVC.swift
//  kartik_testPratical
//
//  Created by kartik on 30/06/21.
//

import UIKit
import TwitterKit
import ObjectMapper

class UserDetailsVC: UIViewController {
    
    var userData: User?
    
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var userIdLbl: UILabel!
    
    @IBOutlet weak var followingLbl: UILabel!
    
    @IBOutlet weak var followersLbl: UILabel!
    
    @IBOutlet weak var userListSegment: UISegmentedControl!
    
    @IBOutlet weak var userListTbl: UITableView!
    var userListArr = [users]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let handlePassListButtonItem = UIBarButtonItem(title: "Passenger List", style: .done, target: self, action: #selector(handlePassListBt))
           self.navigationItem.rightBarButtonItem  = handlePassListButtonItem
        
        if let img = userData?.profile_image,
           let userName = userData?.name,
           let userID = userData?.userName,
           let accessToken = userData?.accessToken,
           let userId = userData?.userId,
           let screenName = userData?.userName
        {
            
            profileImg.imageFromURL(urlString: img)
            userNameLbl.text = userName
            userIdLbl.text = userID
            
            getUserList(accessToken: accessToken,userId: userId,screenName: screenName)
            getFollowersList(accessToken: accessToken,userId: userId,screenName: screenName)
        }
        
    }
    
    @objc func handlePassListBt(){
        let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "PassengerListVC") as! PassengerListVC
        self.navigationController?.pushViewController(storyboard, animated: true)
    }
    
    
    @IBAction func handleListSegment(_ sender: Any) {
        
        switch userListSegment.selectedSegmentIndex
           {
           case 0:
            print(0)
            if let accessToken = userData?.accessToken,
               let userId = userData?.userId,
               let screenName = userData?.userName{
                userListArr.removeAll()
                getUserList(accessToken: accessToken,userId: userId,screenName: screenName)
            }
//               textLabel.text = "First Segment Selected"
           case 1:
            print(1)
            if let accessToken = userData?.accessToken,
               let userId = userData?.userId,
               let screenName = userData?.userName{
                userListArr.removeAll()
                getFollowersList(accessToken: accessToken,userId: userId,screenName: screenName)
            }
//               textLabel.text = "Second Segment Selected"
           default:
               break
           }
    }
    
    func getFollowersList(accessToken:String,userId: String,screenName:String) {
        
        let userId = userId
        let twitterClient = TWTRAPIClient(userID: userId)
        twitterClient.loadUser(withID: userId) { (user, error) in
            if user != nil {
                //Get users timeline tweets
                var request = URLRequest(url: URL(string: "https://api.twitter.com/1.1/followers/list.json?screen_name=\(screenName)")!) //users/lookup, followers/ids, followers/list
                request.httpMethod = "GET"
                request.setValue("Bearer "+accessToken, forHTTPHeaderField: "Authorization")
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in guard let data = data, error == nil else { // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
                }
                
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 { // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                }
                
                do {
                    let response = try JSONSerialization.jsonObject(with: data, options: [])
                    print(response)
                    guard let finalData = response as? [String:Any] else { return }
                    
                    guard let userData = Mapper<FriendListModel>().map(JSON: finalData) else { return }
                    print(userData)
                    
                    if let user = userData.users {
                        self.userListArr = user
                        DispatchQueue.main.async {
                            
                            self.followersLbl.text = "\(user.count) Followers"
                            self.userListTbl.reloadData()
                        }
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
                }
                
                task.resume()
                
            }
        }
        
    }
    
    func getUserList(accessToken:String,userId: String,screenName:String) {
        
        let userId = userId
        let twitterClient = TWTRAPIClient(userID: userId)
        twitterClient.loadUser(withID: userId) { (user, error) in
            if user != nil {
                //Get users timeline tweets
                var request = URLRequest(url: URL(string: "https://api.twitter.com/1.1/friends/list.json?screen_name=\(screenName)")!) //users/lookup, followers/ids, followers/list
                request.httpMethod = "GET"
                request.setValue("Bearer "+accessToken, forHTTPHeaderField: "Authorization")
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in guard let data = data, error == nil else { // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 { // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                }
                
                do {
                    let response = try JSONSerialization.jsonObject(with: data, options: [])
                    print(response)
                    guard let finalData = response as? [String:Any] else { return }
                    
                    guard let userData = Mapper<FriendListModel>().map(JSON: finalData) else { return }
                    print(userData)
                    
                    if let user = userData.users {
                        self.userListArr = user
                        DispatchQueue.main.async {
                            
                            self.followingLbl.text = "\(user.count) Following"
                            self.userListTbl.reloadData()
                        }
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
                }
                
                task.resume()
                
            }
        }
        
    }
}


extension UserDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userListArr.count == 0 {
            tableView.setEmptyMessage("No Data Found...")
        } else {
            tableView.restore()
        }

        return userListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserListTblCell
        let userDataTemp = userListArr[indexPath.row]
        cell.profileImg.imageFromURL(urlString: userDataTemp.profile_image_url ?? "")
        cell.userNameLbl.text = userDataTemp.name
        cell.descLbl.text = userDataTemp.description
        
        cell.mainView.layer.shadowColor = UIColor.gray.cgColor
        cell.mainView.layer.shadowOpacity = 0.3
        cell.mainView.layer.shadowOffset = CGSize.zero
        cell.mainView.layer.shadowRadius = 6
        
        cell.profileImg.layer.masksToBounds = false
        cell.profileImg.layer.cornerRadius = cell.profileImg.frame.height/2
        cell.profileImg.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! UserListTblCell
        self.imageTapped(image: cell.profileImg.image!)
    }
    
    func imageTapped(image:UIImage){
        let newImageView = UIImageView(image: image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    
}
