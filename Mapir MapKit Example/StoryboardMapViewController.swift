//
//  ViewController.swift
//  Mapir MapKit Example
//
//  Created by Alireza Asadi on 19/9/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

import UIKit
import MapirMapKit
import CoreLocation

class StoryboardMapViewController: UIViewController {

    @IBOutlet weak var mapView: SHMapView!

    var selectedFeatureIndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupObservers()

        let center = CLLocationCoordinate2D(latitude: 32.759562, longitude: 53.690186)
        mapView.setCenter(center, zoomLevel: 3.5, animated: false)
    }

    private func setupObservers() {

        NotificationCenter.default.addObserver(forName: SHAccountManager.unauthorizedNotification, object: nil, queue: nil) { (notification) in
            if let error = notification.object as? LocalizedError {
                print("""
                    {
                        Error:   \(error.errorDescription ?? "")
                        Reason:  \(error.failureReason ?? "")
                    }
                    """)
            }
        }
    }
}
