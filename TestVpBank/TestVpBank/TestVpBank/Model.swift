//
//  Model.swift
//  TestVpBank
//
//  Created by sonnh on 8/17/20.
//  Copyright © 2020 FastGo. All rights reserved.
//

import Foundation

struct RootClass : Decodable {
    let data : [SampleData]?
    let message : String?
    let result : Int?
}

struct SampleData {
    var timespan : String?
    let nguyen_1 : String?
    let nguyen_2 : String?
    let nguyen_3 : String?
    let nguyen_4 : String?
    let nguyen_5 : String?
    let nguyen_6 : String?
    let nguyen_7 : String?
    let nguyen_8 : String?
    let nguyen_9 : String?
    let nguyen_10 : String?
    
    init(timespan: String, nguyen_1: String, nguyen_2: String, nguyen_3: String, nguyen_4: String, nguyen_5: String, nguyen_6: String, nguyen_7: String, nguyen_8: String, nguyen_9: String, nguyen_10: String) {
        self.timespan = timespan
        self.nguyen_1 = nguyen_1
        self.nguyen_2 = nguyen_2
        self.nguyen_3 = nguyen_3
        self.nguyen_4 = nguyen_4
        self.nguyen_5 = nguyen_5
        self.nguyen_6 = nguyen_6
        self.nguyen_7 = nguyen_7
        self.nguyen_8 = nguyen_8
        self.nguyen_9 = nguyen_9
        self.nguyen_10 = nguyen_10
    }
    
}

extension SampleData: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case timespan
        case nguyen_1 = "nguyen_1"
        case nguyen_2 = "nguyen_2"
        case nguyen_3 = "nguyen_3"
        case nguyen_4 = "nguyen_4"
        case nguyen_5 = "nguyen_5"
        case nguyen_6 = "nguyen_6"
        case nguyen_7 = "nguyen_7"
        case nguyen_8 = "nguyen_8"
        case nguyen_9 = "nguyen_9"
        case nguyen_10 = "nguyen_10"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self) // defining our (keyed) container
        let timespan: String = try container.decode(String.self, forKey: .timespan)
        let nguyen_1: String = try container.decode(String.self, forKey: .nguyen_1)
        let nguyen_2: String = try container.decode(String.self, forKey: .nguyen_2)
        let nguyen_3: String = try container.decode(String.self, forKey: .nguyen_3)
        let nguyen_4: String = try container.decode(String.self, forKey: .nguyen_4)
        let nguyen_5: String = try container.decode(String.self, forKey: .nguyen_5)
        let nguyen_6: String = try container.decode(String.self, forKey: .nguyen_6)
        let nguyen_7: String = try container.decode(String.self, forKey: .nguyen_7)
        let nguyen_8: String = try container.decode(String.self, forKey: .nguyen_8)
        let nguyen_9: String = try container.decode(String.self, forKey: .nguyen_9)
        let nguyen_10: String = try container.decode(String.self, forKey: .nguyen_10)
        
        
        self.init(timespan: timespan, nguyen_1: nguyen_1, nguyen_2: nguyen_2, nguyen_3: nguyen_3, nguyen_4: nguyen_4, nguyen_5: nguyen_5, nguyen_6: nguyen_6, nguyen_7: nguyen_7, nguyen_8: nguyen_8, nguyen_9: nguyen_9, nguyen_10: nguyen_10)
    }
}
