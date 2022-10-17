//
//  MotivationGroupsNetworkResponse.swift
//  DailyPower
//
//  Created by Artem Malyugin on 01/04/2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

typealias MotivationGroupsNetworkResponse = DecodableNetworkResponse<[MotivationGroupDTO]>

struct MotivationGroupDTO: Codable {

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case videoThumbnailURL = "videoPreview"
        case videoURL = "video"
        case motivations
    }

    let id: Int
    let name: String
    let description: String
    let videoThumbnailURL: URL?
    let videoURL: URL?
    let motivations: [MotivationDTO]
}

struct MotivationDTO: Codable {

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case sortOrder = "sort"
        case videoThumbnailURL = "videoPreview"
        case videoURL = "video"
    }

    let id: Int
    let name: String
    let sortOrder: Int
    let videoThumbnailURL: URL?
    let videoURL: URL?
}
