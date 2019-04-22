//
//  UpdateAction.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/17/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation

enum UpdateAction {
    case initial
    case deletions([Int])
    case insertions([Int])
    case modifications([Int])
}
