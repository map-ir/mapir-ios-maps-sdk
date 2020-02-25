//
//  PolylineExampleViewController.swift
//  Mapir MapKit Example
//
//  Created by Alireza Asadi on 26/11/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

import UIKit
import MapirMapKit

class PolylineExampleViewController: UIViewController, MGLMapViewDelegate {

    var mapView: SHMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create an instane of SHMapView and add it to the view.
        mapView = SHMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        mapView.delegate = self

        let center = CLLocationCoordinate2D(latitude: 32.759562, longitude: 53.690186)
        mapView.setCenter(center, zoomLevel: 3.5, animated: false)

        view.addSubview(mapView)
    }

    // 1: First, we wait for the map to load completely. Doing so will ensure that
    // adding new annotations to the map will also show them on the map.
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {

        // Coordinates of first 10 stations of tehran metro line number 1, starting from
        // Tajrish station. We are going to show a polyline that shows the route of metro
        // train along these stations.
        let tehranMetroLine1 = [
            CLLocationCoordinate2D(latitude: 35.805072, longitude: 51.433924),
            CLLocationCoordinate2D(latitude: 35.794073, longitude: 51.434439),
            CLLocationCoordinate2D(latitude: 35.784465, longitude: 51.435812),
            CLLocationCoordinate2D(latitude: 35.774438, longitude: 51.436842),
            CLLocationCoordinate2D(latitude: 35.764688, longitude: 51.443194),
            CLLocationCoordinate2D(latitude: 35.760649, longitude: 51.430834),
            CLLocationCoordinate2D(latitude: 35.755773, longitude: 51.426199),
            CLLocationCoordinate2D(latitude: 35.748529, longitude: 51.426028),
            CLLocationCoordinate2D(latitude: 35.739612, longitude: 51.426543),
            CLLocationCoordinate2D(latitude: 35.730833, longitude: 51.425684),
        ]

        // 2: Create a polyline using the given coordinates. Since these functions come
        // from Objective-C world, you have to specify the count of coordinates.
        let polyline = MGLPolyline(coordinates: tehranMetroLine1, count: UInt(tehranMetroLine1.count))

        // 3: Add the polyline to the map.
        mapView.addAnnotation(polyline)

        // Recenters the map view to zoom over the first 10 stations of Tehran Metro line 1.
        let center = CLLocationCoordinate2D(latitude: 35.764688, longitude: 51.443194)
        mapView.setCenter(center, zoomLevel: 12, animated: true)
    }

    // MARK: - MGLMapViewDelegate methods

    // 4: Use this function from delegate methods to set a line width for polyline
    // annotations shown on the map.
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        return CGFloat(3.0)
    }

    // 5: Use this function from delegate methods to specify a line color for shape
    // annotations shown on the map.
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return UIColor(red: 218 / 255, green: 44 / 255, blue: 56 / 255, alpha: 1.0)
    }
}
