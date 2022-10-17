//
//  Document+Extensions.swift
//  DailyPower
//
//  Created by Alexey N. Yukin on 14.02.2019.
//  Copyright © 2019 mobile.Simbirsoft. All rights reserved.
//

import Foundation

extension Document {

    static let userAgreement = Document(
        url: R.file.userAgreementRtf()!,
        title: R.string.localizable.document_title_user_agreement()
    )

    static let privacyPolicy = Document(
        url: R.file.privacyPolicyRtf()!,
        title: R.string.localizable.document_title_privacy_policy()
    )
}
