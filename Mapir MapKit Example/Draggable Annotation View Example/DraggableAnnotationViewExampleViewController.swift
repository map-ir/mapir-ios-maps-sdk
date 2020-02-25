//
//  DraggableAnnotationViewExampleViewController.swift
//  Mapir MapKit Example
//
//  Created by Alireza Asadi on 27/11/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

import UIKit
import MapirMapKit

class DraggableAnnotationViewExampleViewController: UIViewController, SHMapViewDelegate {

    var mapView: SHMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create an instane of SHMapView and add it to the view.
        mapView = SHMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        mapView.styleURL = SHStyle.isatisStyleURL
        mapView.delegate = self

        let center = CLLocationCoordinate2D(latitude: 32.636917, longitude: 51.680889)
        mapView.setCenter(center, zoomLevel: 11, animated: false)

        view.addSubview(mapView)

        let coordinates = [
            CLLocationCoordinate2D(latitude: 32.625352, longitude: 51.720542),
            CLLocationCoordinate2D(latitude: 32.639374, longitude: 51.694278),
            CLLocationCoordinate2D(latitude: 32.636917, longitude: 51.680889),
            CLLocationCoordinate2D(latitude: 32.645012, longitude: 51.667499),
            CLLocationCoordinate2D(latitude: 32.636483, longitude: 51.634197),
        ]

        // 1: Create and add point annotations to the map. In another part we will update
        // the view associated with them.
        var pointAnnotations: [MGLPointAnnotation] = []
        for coordinate in coordinates {
            let point = MGLPointAnnotation()
            point.coordinate = coordinate
            point.title = "To drag this annotation, first tap and hold."
            pointAnnotations.append(point)
        }

        mapView.addAnnotations(pointAnnotations)
    }

    // MARK: - MGLMapViewDelegate methods

    // 2: Return value of this function is going to specify the view that each point
    // annotation will be shown with it, on the map. You can use a static
    // MGLAnnotationImage using `func mapView(_:imageFor:)`.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {

        // 3: In this example, we want to be sure of that the annotations we update, are of
        // type MGLPointAnnotation.
        guard annotation is MGLPointAnnotation else { return nil }

        // 4: We specify a name as its reuse identifier. So, in the future we can reuse a
        // view instead of making a new one.
        let reuseID = "Draggable Point Annoatation"

        // 5: As mentioned before, alwayse try to reuse existing views. This approach
        // enhances performance of the map.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)

        // 6: If the annotation view does not exist, initialize a new draggable annoation.
        if annotationView == nil {
            annotationView = DraggableAnnotationView(reuseIdentifier: reuseID, size: CGSize(width: 40.0, height: 40.0))
        }

        // 7: Return the annotation
        return annotationView
    }

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }

}
