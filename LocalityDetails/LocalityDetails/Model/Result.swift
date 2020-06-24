//
//  Result.swift
//  LocalityDetails
//
//  Created by fkhader on 6/25/20.
//  Copyright © 2020 fkhader. All rights reserved.
//

import Foundation

enum Result<ResultType> {
    case results(ResultType)
    case error(Error)
}
