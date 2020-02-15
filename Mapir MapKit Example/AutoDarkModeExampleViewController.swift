//
//  AutoDarkModeExampleViewController.swift
//  Mapir MapKit Example
//
//  Created by Alireza Asadi on 26/11/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

import UIKit
import MapirMapKit

class AutoDarkModeExampleViewController: UIViewController {

    var mapView: SHMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create an instane of SHMapView and add it to the view.
        mapView = SHMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        let center = CLLocationCoordinate2D(latitude: 32.759562, longitude: 53.690186)
        mapView.setCenter(center, zoomLevel: 3.5, animated: false)

        view.addSubview(mapView)

        // 1: Create a new configuration obejct for dark mode. You have to specify two
        // styles, one for day time and one for night time. Finally you have to specify a
        // center coordinate which is used to calculate the sunset and sunrise time.
        let autoDarkModeConfig = SHAutoDarkModeConfiguration(
            lightStyleURL: SHStyle.vernaStyleURL,
            darkStyleURL: SHStyle.carmaniaStyleURL,
            coordinate: center
        )

        // 2: Add your own configuration to mapView.
        mapView.autoDarkModeConfiguration = autoDarkModeConfig

        // 3: In the end, set autoDarkMode property to updateAutomatically. After that, at
        // sunset and sunrise, style will be updated to what you specifyied before.
        mapView.autoDarkMode = .updateAutomatically
    }
}
