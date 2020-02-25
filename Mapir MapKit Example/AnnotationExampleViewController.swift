//
//  AnnotationExampleViewController.swift
//  Mapir MapKit Example
//
//  Created by Alireza Asadi on 26/11/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

import UIKit
import MapirMapKit

class AnnotationExampleViewController: UIViewController, SHMapViewDelegate {

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
        
        // Coordinates of the places that will be shown on the map.
        let places: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 35.704442, longitude: 51.409291),
            CLLocationCoordinate2D(latitude: 35.700678, longitude: 51.405729),
            CLLocationCoordinate2D(latitude: 35.704372, longitude: 51.394529),
            CLLocationCoordinate2D(latitude: 35.711655, longitude: 51.392297),
        ]

        // 2: Create an empty array of annotations to add newly created point annotaions to it.
        var annotations: [MGLPointAnnotation] = []
        for coordinate in places {

            // 3: Create a point annotation and set its coordinate and title.
            let newAnnotation = MGLPointAnnotation()
            newAnnotation.coordinate = coordinate
            newAnnotation.title = "\(coordinate.latitude), \(coordinate.longitude)"

            // 4: Add the annotation to the array.
            annotations.append(newAnnotation)
        }

        // 5: Add array of annotations to the mapView.
        mapView.addAnnotations(annotations)

        // Recenter the map view to zoom over the point annotations.
        let center = CLLocationCoordinate2D(latitude: 35.706219, longitude: 51.400794)
        mapView.setCenter(center, zoomLevel: 13, animated: true)
    }

    // 6: Permit the map view to show callouts when user taps an annotation.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        true
    }
}
