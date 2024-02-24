//
//  CharacterStatus.swift
//  RickAndMortyAPI
//
//  Created by Omar Jiménez Sotelo on 23/02/24.
//

import Foundation

enum CharacterStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case `unknown` = "unknown"
    case all = ""

    var text: String {
        switch self {
        case .alive, .dead:
            return rawValue
        case .unknown:
            return "Unknown"
        case .all:
            return ""
//            return "Alive, Dead, unknown"
        }
    }
}
