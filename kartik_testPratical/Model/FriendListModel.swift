//
//  FriendListModel.swift
//  kartik_testPratical
//
//  Created by kartik on 30/06/21.
//

import Foundation
import ObjectMapper

class FriendListModel: Mappable {
    
//    "next_cursor" = 1703919350756773020;
//      "next_cursor_str" = 1703919350756773020;
//      "previous_cursor" = 0;
//      "previous_cursor_str" = 0;
//      "total_count" = "<null>";
    
    var next_cursor: Int?
    var next_cursor_str: Int?
    var previous_cursor: Int?
    var previous_cursor_str: Int?
    var total_count: String?
    var users: [users]?
    required init?(map: Map) {
    }

    func mapping(map: Map) {
        next_cursor <- map["next_cursor"]
        next_cursor_str <- map["next_cursor_str"]
        previous_cursor <- map["previous_cursor"]
        previous_cursor_str <- map["previous_cursor_str"]
        total_count <- map["total_count"]
        users <- map["users"]
    }
}

class users: Mappable {
    
//    name = "Suresh Raina\Ud83c\Uddee\Ud83c\Uddf3";
//    "profile_image_url" = "http://pbs.twimg.com/profile_images/1408299443489624064/T94rW6S9_normal.jpg";
//   description = "Professional Cricketer \Ud83c\Uddee\Ud83c\Uddf3, Co-Founder @maatecare, @grfcare  \Ud83d\Udce7 - team@sureshraina.com  For queries, contact Anand Kanwar +919899005693";
//      "previous_cursor_str" = 0;
//      "total_count" = "<null>";
    
   
    var name: String?
    var profile_image_url: String?
    var description: String?
    required init?(map: Map) {
    }

    func mapping(map: Map) {
        name <- map["name"]
        profile_image_url <- map["profile_image_url"]
        description <- map["description"]
    }
}
