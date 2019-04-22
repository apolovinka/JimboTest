//
//  Unmanaged+Utils.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/18/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation

extension Unmanaged {

    static func objectAddress(_ instance: Instance) -> String {
        return String(describing: Unmanaged.passUnretained(instance).toOpaque())
    }

}
