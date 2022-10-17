//
//  UserProfileNetworkResponse.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 28.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

typealias UserProfileNetworkResponse = DecodableNetworkResponse<UserProfileDTO>

struct UserProfileDTO: Codable {

    let email: String
    let images: ImagesDTO
}

struct ImagesDTO: Codable {

    enum CodingKeys: String, CodingKey {
        case beforeURL = "before"
        case afterURL = "after"
    }

    let beforeURL: URL?
    let afterURL: URL?
}
