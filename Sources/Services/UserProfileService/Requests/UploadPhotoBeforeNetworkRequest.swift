//
//  UploadPhotoBeforeNetworkRequest.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 29.03.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

struct UploadPhotoBeforeNetworkRequest: NetworkRequest {

    let httpMethod: NetworkRequestHTTPMethod = .post
    let path: NetworkRequestPath = .relative("mobile/profile/images/before")
    let requiredAuthentication: NetworkRequestAuthenticationType = .token
    let taskParameters: NetworkRequestTaskParameters

    init(data: Data) {
        taskParameters = .multipart(data: data, name: "image", mimeType: "image/jpeg")
    }
}
