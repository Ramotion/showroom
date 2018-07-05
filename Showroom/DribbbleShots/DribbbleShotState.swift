//
//  DribbbleShotState.swift
//  Showroom
//
//  Created by Dmitry Nesterenko on 05/07/2018.
//  Copyright © 2018 Alex K. All rights reserved.
//

import Foundation

enum DribbbleShotState {
    
    case `default`(shot: Shot)
    case sent(shot: Shot)
    case wireframe
    
    init(shot: Shot, sent: Bool) {
        if sent {
            self = .sent(shot: shot)
        } else {
            self = .default(shot: shot)
        }
    }
    
    var imageUrl: URL? {
        switch self {
        case .default(let shot):
            return shot.imageUrl
        case .sent(let shot):
            return shot.imageUrl
        case .wireframe:
            return nil
        }
    }
    
}
