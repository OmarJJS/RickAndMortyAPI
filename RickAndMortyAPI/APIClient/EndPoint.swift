//
//  EndPoint.swift
//  RickAndMortyAPI
//
//  Created by Omar Jiménez Sotelo on 22/02/24.
//

import Foundation

@frozen enum Endpoint: String, CaseIterable, Hashable {
    
    case character
    case location
    case episode
    
}
