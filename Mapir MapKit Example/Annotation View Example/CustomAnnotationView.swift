//
//  CustomAnnotationView.swift
//  Mapir MapKit Example
//
//  Created by Alireza Asadi on 26/11/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

import UIKit
import MapirMapKit

// 1: Create a subclass of MGLAnnotationView to use it to show annotations on the map using this new class.
class CustomAnnotationView: MGLAnnotationView {

    // 2: At the time when the view gets layed out, design the view using its CALayer
    // properties.
    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.width / 2
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.white.cgColor
    }

    // 3: Update the view when it gets selected, using this method.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // 4: In this example we will animate the border width. It gets larger whenever the
        // view gets selected, and vice versa.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.2
        layer.borderWidth = selected ? 8 : 2
        layer.add(animation, forKey: "borderWidth")
    }
}
