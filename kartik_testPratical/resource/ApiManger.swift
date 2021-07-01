//
//  ApiManger.swift
//  kartik_testPratical
//
//  Created by kartik on 30/06/21.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper

class ApiManger: NSObject {
    static let sharedInstance = ApiManger()
    func getUserMapple(completionHandler: @escaping (_ userData: PassengerListModel) -> ()) {
            
            guard let urlString = URL(string: "https://api.instantwebtools.net/v1/passenger?page=0&size=10") else { return }
            
            AF.request(urlString).responseJSON { (responce) in
                
                switch responce.result {
                case .success(let value):
                    guard let castingValue = value as? [String: Any] else { return }
                    guard let userData = Mapper<PassengerListModel>().map(JSON: castingValue) else { return }
                completionHandler(userData)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
      }
}
