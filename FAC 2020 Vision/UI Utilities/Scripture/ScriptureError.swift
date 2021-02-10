//
//  ScriptureError.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2020-12-15.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import Foundation

enum ScriptureError: Error {
    case bookNotFound
    case requestError(message: String)
}
