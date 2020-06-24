//
//  CountryDetails.swift
//  Simple URL Request
//
//  Created by fkhader on 6/24/20.
//  Copyright © 2020 fkhader. All rights reserved.
//

import Foundation

struct CountryDetails {
    let title: String?
    let description: String?
    let imageHref: String?
    
    init(title: String?, description: String?, imageHref: String?) {
        self.title = title
        self.description = description
        self.imageHref = imageHref
    }
}
