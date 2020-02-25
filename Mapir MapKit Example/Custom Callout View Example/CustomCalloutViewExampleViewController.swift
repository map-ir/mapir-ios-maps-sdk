//
//  CustomCalloutViewExampleViewController.swift
//  Mapir MapKit Example
//
//  Created by Alireza Asadi on 27/11/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

import UIKit
import MapirMapKit

class CustomCalloutViewExampleViewController: UIViewController, SHMapViewDelegate, MGLCalloutViewDelegate {

    var mapView: SHMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create an instane of SHMapView and add it to the view.
        mapView = SHMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        mapView.styleURL = SHStyle.isatisStyleURL
        mapView.delegate = self

        let center = CLLocationCoordinate2D(latitude: 29.484212, longitude: 60.873355)
        mapView.setCenter(center, zoomLevel: 11, animated: false)

        view.addSubview(mapView)

        let places = [
            "15 Khordad Sq.":
                CLLocationCoordinate2D(latitude: 29.502515, longitude: 60.855717),
            "University of Sistan and Baluchestan":
                CLLocationCoordinate2D(latitude: 29.464186, longitude: 60.857477),
            "Zahedan Airport":
                CLLocationCoordinate2D(latitude: 29.476441, longitude: 60.899534),
        ]

        // 1: Create and add point annotations to the map. In another part we will update
        // the callout view associated with them.
        var pointAnnotations: [MGLPointAnnotation] = []
        for place in places {
            let point = MGLPointAnnotation()
            point.coordinate = place.value
            point.title = place.key
            pointAnnotations.append(point)
        }

        mapView.addAnnotations(pointAnnotations)
    }

    // MARK: - MGLMapViewDelegate methods

    // 2: Allow annotations to present callouts.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }

    // 3: Here we return our customized version of callouts for all annotations on the
    // map. Also, we set their delegate to be current view controller. So, we can later
    // handle callout view events.
    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
        let calloutView = CustomCalloutView(representedObject: annotation)
        calloutView.delegate = self
        return calloutView
    }

    // MARK: - MGLCalloutViewDelegate methods

    // 4: Allow a callout to be highlighted. This mean that the whole callout view gets
    // highlighted when user taps it.
    func calloutViewShouldHighlight(_ calloutView: UIView & MGLCalloutView) -> Bool {
        return true
    }

    // 5: In this method you can handle user taps on the callout view.
    func calloutViewTapped(_ calloutView: UIView & MGLCalloutView) {
        let annotation = calloutView.representedObject
        mapView.deselectAnnotation(annotation, animated: true)
    }
}
