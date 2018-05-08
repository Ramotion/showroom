//
//  Shot.swift
//  Showroom
//
//  Created by Alex K on 08/05/2018.
//  Copyright © 2018 Alex K. All rights reserved.
//

import Foundation

struct Shot: Codable {
    let description: String?
    let html_url: String
    let title: String
    let images: Images
    
    struct Images: Codable {
        let normal: String
    }
}
