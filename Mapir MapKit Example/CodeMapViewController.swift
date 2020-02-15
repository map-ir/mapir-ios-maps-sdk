//
//  CodeMapViewController.swift
//  Mapir MapKit Example
//
//  Created by Alireza Asadi on 26/11/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

import UIKit
import MapirMapKit

class CodeMapViewController: UIViewController {

    // 1: Create a force-unwrapped property for the map view. force unwrapping will not
    // cause crashes, since it will be initialized before being used.
    var mapView: SHMapView!

    // 2: viewDidLoad() is the first proper place in view controller's life cycle
    // methods to initialize the mapView propery.
    override func viewDidLoad() {
        super.viewDidLoad()

        // 3: Initialize a fullscreen SHMapView using view's bound property and assign it
        // to mapView property, so we can access it later in other functions.
        mapView = SHMapView(frame: view.bounds)

        // 4: Set up the autoresizing mask, therefore the view will be updated
        // automatically when the bounds change. For example, when the device rotates,
        // view's bounds will change, and map view's frame will be updated.
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        let center = CLLocationCoordinate2D(latitude: 32.759562, longitude: 53.690186)

        // 5: Set the center of the map. Since the map may not be loaded at the moment, you
        // should set animated propery to false, or it may not move the camera to the
        // specified coordinates. As soon at map loads, you can set center of the map with
        // animations.
        mapView.setCenter(center, zoomLevel: 3.5, animated: false)

        // 6: Finally, add the mapView to view controller's view propery as a subview.
        view.addSubview(mapView)
    }

}
