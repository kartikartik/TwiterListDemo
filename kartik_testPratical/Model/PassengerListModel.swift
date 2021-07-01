//
//  PassengerListModel.swift
//  kartik_testPratical
//
//  Created by kartik on 30/06/21.
//

import Foundation
import ObjectMapper
        
class PassengerListModel : Mappable{

        var totalPassengers : Int?
        var data : [data]?
        var totalPages : Int?
    
        required init?(map: Map) {
        }
    
        func mapping(map: Map) {
            totalPassengers <- map["totalPassengers"]
            data <- map["data"]
            totalPages <- map["totalPages"]
        }
    }
    
class data: Mappable {
    var _id: String?
    var __v: Int?
    var name: String?
    var trips: Int?
    var airline : airline?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _id <- map["_id"]
        __v <- map["__v"]
        name <- map["name"]
        trips <- map["trips"]
        airline <- map["airline"]
    }
}
    class airline : Mappable{
        
//        "airline": {
//                "id": 5,
//                "name": "Eva Air",
//                "country": "Taiwan",
//                "logo": "https://upload.wikimedia.org/wikipedia/en/thumb/e/ed/EVA_Air_logo.svg/250px-EVA_Air_logo.svg.png",
//                "slogan": "Sharing the World, Flying Together",
//                "head_quaters": "376, Hsin-Nan Rd., Sec. 1, Luzhu, Taoyuan City, Taiwan",
//                "website": "www.evaair.com",
//                "established": "1989"
//              },
        var name : String?
        var country : String?
        var logo : String?
        var slogan : String?
        var head_quaters : String?
        var website : String?
        var established : String?
        
        required init?(map: Map) {
            
        }
        
        func mapping(map: Map) {
            name <- map["name"]
            country <- map["country"]
            logo <- map["logo"]
            slogan <- map["slogan"]
            head_quaters <- map["head_quaters"]
            website <- map["website"]
            established <- map["established"]
        }
    }
