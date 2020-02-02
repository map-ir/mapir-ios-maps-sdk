//
//  Feature.swift
//  Mapir MapKit Example
//
//  Created by Alireza Asadi on 24/9/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

import Foundation
import MapirMapKit

struct Feature {
    var title: String
    var description: String?

    var task: ((SHMapView) -> ())?
}

extension Feature: Hashable {

    static func == (lhs: Feature, rhs: Feature) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }

}
