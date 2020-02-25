//
//  PolygonExampleViewController.swift
//  Mapir MapKit Example
//
//  Created by Alireza Asadi on 26/11/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

import UIKit
import MapirMapKit

class PolygonExampleViewController: UIViewController, MGLMapViewDelegate {

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

        // Coordinates of Tehran University area. We are going to show a polygon that
        // indicates the area on the map. In the polygon we want to exclude area of central
        // library in the university. To create a polygon, the first an last item in the
        // array of coordinates must be the same. Otherwise, the area shown on the map may
        // not be as it was expected.
        let tehranUniversityCoordinates: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 35.706978, longitude: 51.395716),
            CLLocationCoordinate2D(latitude: 35.705985, longitude: 51.392165),
            CLLocationCoordinate2D(latitude: 35.701167, longitude: 51.394300),
            CLLocationCoordinate2D(latitude: 35.701245, longitude: 51.398216),
            CLLocationCoordinate2D(latitude: 35.706978, longitude: 51.395716), // It's the same as the first one.
        ]

        // Coordinates of area that we want to exclude from the main polygon. Since the
        // exclusion zone is polygon itself, same rule about first and last item of in
        // the array of coordinates are true here.
        let exclusionZoneCoordinates: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 35.703435, longitude: 51.394834),
            CLLocationCoordinate2D(latitude: 35.703651, longitude: 51.395607),
            CLLocationCoordinate2D(latitude: 35.703102, longitude: 51.395835),
            CLLocationCoordinate2D(latitude: 35.702895, longitude: 51.395060),
            CLLocationCoordinate2D(latitude: 35.703435, longitude: 51.394834), // It's the same as the first one.
        ]

        // 2: Create the exclusion zone polygon using the given coordinates. For the reason
        // that these functions come from Objective-C world, you have to specify the count
        // of coordinates.
        let exclusionZone = MGLPolygon(
            coordinates: exclusionZoneCoordinates,
            count: UInt(exclusionZoneCoordinates.count)
        )

        // 3: Create the main zone polygon using the given coordinates. here we specify the
        // exclusionZone as the interior polygon. interior polygon will be excluded from
        // the main area. For the reason that these functions come from Objective-C world,
        // you have to specify the count of coordinates.
        let polygon = MGLPolygon(
            coordinates: tehranUniversityCoordinates,
            count: UInt(tehranUniversityCoordinates.count),
            interiorPolygons: [exclusionZone]
        )

        // 4: Add the polygon to the map.
        mapView.addAnnotation(polygon)

        // Recenters the map view to zoom over the Tehran University area.
        let center = CLLocationCoordinate2D(latitude: 35.704007705813055, longitude: 51.3951051235199)
        mapView.setCenter(center, zoomLevel: 15, animated: true)
    }

    // MARK: - MGLMapViewDelegate methods

    // 5: Use this function from delegate methods to set a fill color for polygon
    // annotations shown on the map.
    func mapView(_ mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
        return UIColor(red: 10 / 255, green: 36 / 255, blue: 99 / 255, alpha: 0.3)
    }

    // 6: Use this function from delegate methods to specify a line color for shape
    // annotations shown on the map.
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return UIColor(red: 10 / 255, green: 36 / 255, blue: 99 / 255, alpha: 1.0)
    }
}
