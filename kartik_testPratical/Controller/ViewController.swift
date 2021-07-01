//
//  ViewController.swift
//  kartik_testPratical
//
//  Created by kartik on 29/06/21.
//

import UIKit
import TwitterKit

class ViewController: UIViewController {
    
    var userData: User?
    var accessToken = String()
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "twitter")
        imageView.image = image
        navigationItem.titleView = imageView
        
        if let accToken = defaults.string(forKey: "accessToken") {
            print(accToken)
        }else{
            getAccessToken()
            
        }
        
        
    }
    
    @IBAction func twitterLoginHandle(_ sender: Any) {
        
        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
            let name = session?.userName ?? ""
            print(name)
            print(session?.userID  ?? "")
            print(session?.authToken  ?? "")
            print(session?.authTokenSecret  ?? "")
            let client = TWTRAPIClient.withCurrentUser()
            client.requestEmail { email, error in
                if (email != nil) {
                    let recivedEmailID = email ?? ""
                    print(recivedEmailID)
                }else {
                    print("error--: \(String(describing: error?.localizedDescription))");
                }
            }
            
            //To get profile image url and screen name
            let twitterClient = TWTRAPIClient(userID: session?.userID)
            twitterClient.loadUser(withID: session?.userID ?? "") {(user, error) in
                print(user?.name ?? "")
                print(user?.profileImageURL ?? "")
                print(user?.profileImageLargeURL ?? "")
                print(user?.screenName ?? "")
                let accToken = self.defaults.string(forKey: "accessToken") ?? ""
                let _:User = {
                    let data = User(authToken: session?.authToken  ?? "",userName: name, name: user?.name ?? "",profile_image: user?.profileImageLargeURL ?? "",userId: session?.userID  ?? "",accessToken:accToken)
                    self.userData = data
                    print(self.userData)
                    let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailsVC") as! UserDetailsVC
                    storyboard.userData = self.userData
                    self.navigationController?.pushViewController(storyboard, animated: true)
                    return data
                }()
            }
            
            
        })
    }
    
    
    func getAccessToken() {
        
        //RFC encoding of ConsumerKey and ConsumerSecretKey
        let encodedConsumerKeyString:String = "Sh4JYw4aQ773emLJTL9zlFFF2"
        let encodedConsumerSecretKeyString:String = "KYZk6x2O0HO8e1ClUyqDDMjXOnYJhjwHBXrY4PJ6M7OFBxkE7z"
        print(encodedConsumerKeyString)
        print(encodedConsumerSecretKeyString)
        //Combine both encodedConsumerKeyString & encodedConsumerSecretKeyString with " : "
        let combinedString = encodedConsumerKeyString+":"+encodedConsumerSecretKeyString
        print(combinedString)
        //Base64 encoding
        let data = combinedString.data(using: .utf8)
        let encodingString = "Basic "+(data?.base64EncodedString())!
        print(encodingString)
        //Create URL request
        var request = URLRequest(url: URL(string: "https://api.twitter.com/oauth2/token")!)
        request.httpMethod = "POST"
        request.setValue(encodingString, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        let bodyData = "grant_type=client_credentials".data(using: .utf8)!
        request.setValue("\(bodyData.count)", forHTTPHeaderField: "Content-Length")
        request.httpBody = bodyData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in guard let data = data, error == nil else { // check for fundamental networking error
            print("error=\(String(describing: error))")
            return
        }
        
        let responseString = String(data: data, encoding: .utf8)
        let dictionary = data
        print("dictionary = \(dictionary)")
        print("responseString = \(String(describing: responseString!))")
        
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 { // check for http errors
            print("statusCode should be 200, but is \(httpStatus.statusCode)")
            print("response = \(String(describing: response))")
        }
        
        do {
            let response = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, Any>
            print("Access Token response : \(response)")
            
            if let token = response["access_token"] {
                
                print(token)
                self.accessToken = token as! String
                self.defaults.set(self.accessToken, forKey: "accessToken")
            }
            
            //  self.getStatusesUserTimeline(accessToken:self.accessToken)
            
        } catch let error as NSError {
            print(error)
        }
        }
        
        task.resume()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    }
    
}

