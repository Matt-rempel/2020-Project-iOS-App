//
//  DBAccessError.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2020-12-15.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import Foundation

enum DBAccessError: Error {
    case dataNotFound
    case badData
    case nextURLNotFound
    case nonFieldError(message: String?)
    case couldNotEncodeData
}
