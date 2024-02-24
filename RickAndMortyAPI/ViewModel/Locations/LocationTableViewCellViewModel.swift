//
//  LocationTableViewCellViewModel.swift
//  RickAndMortyAPI
//
//  Created by Omar Jiménez Sotelo on 23/02/24.
//

import Foundation

struct LocationTableViewCellViewModel: Hashable, Equatable {

    private let location: Location

    init(location: Location) {
        self.location = location
    }

    public var name: String {
        return location.name
    }

    public var type: String {
        return "Type: "+location.type
    }

    public var dimension: String {
        return location.dimension
    }

    static func == (lhs: LocationTableViewCellViewModel, rhs: LocationTableViewCellViewModel) -> Bool {
        return lhs.location.id == rhs.location.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(location.id)
        hasher.combine(dimension)
        hasher.combine(type)
    }
}
