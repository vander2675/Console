//
//  Color.swift
//  
//
//  Created by Pascal van der Locht on 30.03.21.
//

import Foundation

public extension Console {

    enum Color: String {
        case `default` = "[0;0m"
        case black = "[0;30m"
        case red = "[0;31m"
        case green = "[0;32m"
        case yellow = "[0;33m"
        case blue = "[0;34m"
        case magenta = "[0;35m"
        case cyan = "[0;36m"
        case white = "[0;37m"
    }



}
