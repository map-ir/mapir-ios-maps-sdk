//
//  ViewController.swift
//  Mapir MapKit Example
//
//  Created by Alireza Asadi on 19/9/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

import UIKit
import MapirMapKit

// 0: Before start, go to your storyboard and from library, add a UIView to your
// view controller. then select it and open identity inspector. Then choose
// SHMapView as the class in custom class section. Set up whatever constraint you
// want.

class StoryboardMapViewController: UIViewController {

    // 1: Control + Drag from the view in storyboard and drop it in the view
    // controller. choose type to be "Outlet". Name it properly, we call it "mapView".
    @IBOutlet weak var mapView: SHMapView!

    // 2: In viewWillAppear(_:) we will set a center and zoom level fo the map.
    // therefore, whenever the view controller disappears and reappears, the map's
    // center and zoom level will change to the default.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let center = CLLocationCoordinate2D(latitude: 32.759562, longitude: 53.690186)

        // 3: We set the center of the map without animations for 2 reasons. First, we
        // don't want the view to reappear along with the map's camera moving at the same
        // time. Second, in the first time that the map view is loading, the map may not be
        // loaded at the moment, you should set animated propery to false, or it may not
        // move the camera to the specified coordinates. As soon at map loads, you can set
        // center of the map with animations.
        mapView.setCenter(center, zoomLevel: 3.5, animated: false)
    }
}
