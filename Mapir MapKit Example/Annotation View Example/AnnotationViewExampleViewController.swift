//
//  AnnotationViewExampleViewController.swift
//  Mapir MapKit Example
//
//  Created by Alireza Asadi on 26/11/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

import UIKit
import MapirMapKit

class AnnotationViewExampleViewController: UIViewController, SHMapViewDelegate {

    var mapView: SHMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create an instane of SHMapView and add it to the view.
        mapView = SHMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        mapView.styleURL = SHStyle.isatisStyleURL
        mapView.delegate = self

        let center = CLLocationCoordinate2D(latitude: 38.075122, longitude: 46.295013)
        mapView.setCenter(center, zoomLevel: 9, animated: false)

        view.addSubview(mapView)

        let coordinates = [
            CLLocationCoordinate2D(latitude: 38.013476, longitude: 46.167984),
            CLLocationCoordinate2D(latitude: 38.013476, longitude: 46.416549),
            CLLocationCoordinate2D(latitude: 38.141037, longitude: 46.416549),
            CLLocationCoordinate2D(latitude: 38.141037, longitude: 46.167984),
        ]

        let titles = ["Bottom Left", "Bottom Right", "Top Right", "Top Left"]

        // 1: Create and add point annotations to the map. then we will update the view
        // associated with them.
        var pointAnnotations: [MGLPointAnnotation] = []
        for (index, coordinate) in coordinates.enumerated() {
            let point = MGLPointAnnotation()
            point.coordinate = coordinate
            point.title = titles[index]
            pointAnnotations.append(point)
        }

        mapView.addAnnotations(pointAnnotations)
    }

    // MARK: - MGLMapViewDelegate methods

    // 2: Return value of this function is going to specify the view that each point
    // annotation will be shown with it, on the map. You can use a static
    // MGLAnnotationImage using `func mapView(_:imageFor:)`. If the return value
    // becomes nil, default annotation view will be used.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {

        // 3: In this example, we want to be sure of that the annotations we update, are of
        // type MGLPointAnnotation.
        guard annotation is MGLPointAnnotation else { return nil }

        // 4: We specify a combination of annotation's latitude and longitude as its reuse
        // identifier. So, in the future we can reuse a view instead of making a new one.
        let reuseID = "\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)"

        // 5: As mentioned before, alwayse try to reuse existing views. This approach
        // enhances performance of the map.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)

        // 6: If the annotation view does not exist, initialize and modify one.
        if annotationView == nil {
            annotationView = CustomAnnotationView(reuseIdentifier: reuseID)
            annotationView!.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)

            // 7: Set a background color for the annotation view.
            annotationView!.backgroundColor = UIColor(hue: .random(in: 0...1), saturation: 0.5, brightness: 1.0, alpha: 1.0)
        }

        // 8: Return the annotation
        return annotationView
    }

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }

}
