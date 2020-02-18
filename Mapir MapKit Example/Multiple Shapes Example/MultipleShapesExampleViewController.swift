//
//  MultipleShapesExampleViewController.swift
//  Mapir MapKit Example
//
//  Created by Alireza Asadi on 28/11/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

import UIKit
import MapirMapKit

class MultipleShapesExampleViewController: UIViewController, MGLMapViewDelegate {

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

    // MARK: - MGLMapViewDelegate methods

    // 1: First, we wait for the map to load the style. Doing so will ensure that
    // adding new layers sill be successful.
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {

        // 2: There is a GeoJSON file in the application bundle which contains information
        // about Shiraz metro line 1 and its stations. In this example we will show the
        // line and stations on the map.
        guard let ShirazMetroGeoJSONPath = Bundle.main.path(forResource: "ShirazMetro", ofType: "geojson") else { return }
        let url = URL(fileURLWithPath: ShirazMetroGeoJSONPath)

        // 3: Create a shape source with a unique and declarative identifier, a url (of GeoJSON file) and
        // dictionary of options as you want.
        let shapeSource = MGLShapeSource(identifier: "shiraz-metro", url: url, options: nil)

        // 4: Add the shape source to the map's style.
        style.addSource(shapeSource)

        // 5: Create style layer for the shape source.
        addMetroLine(from: shapeSource, to: style)
        addMetroStations(from: shapeSource, to: style)

        // Recenters the map view to zoom over the first 10 stations of Tehran Metro line 1.
        let center = CLLocationCoordinate2D(latitude: 29.606595, longitude: 52.529067)
        mapView.setCenter(center, zoomLevel: 11, direction: 320, animated: true)
    }

    // MARK: - Creating Layers

    func addMetroLine(from source: MGLShapeSource, to style: MGLStyle) {

        // 6: To show a line on the map, use an instance of MGLLineStyleLayer. Create one with
        // a unique identifier and related source. Then configue it to represent the metro
        // line.
        let lineLayer = MGLLineStyleLayer(identifier: source.identifier + "-line", source: source)

        // 7: Use a predicates to filter the metro line from the shape source. In current
        // example, metro line has a "fclass" property equal to "subway_line".
        lineLayer.predicate = NSPredicate(format: "fclass = 'subway_line'")
        lineLayer.lineColor = NSExpression(forConstantValue: UIColor.red)

        // 8: Using "mgl_interpolate:withCurveType:parameters:stops:" expressions, you can
        // specify a line width value that changes based on variation of some of map's
        // properties like zoom level. In this case, we bind line width to map's zoom
        // level.
        lineLayer.lineWidth = NSExpression(
            format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', 2, %@)",
            [12: 2, 18: 8]
        )

        // 9: Finally add the line layer to the style.
        style.addLayer(lineLayer)
    }

    func addMetroStations(from source: MGLShapeSource, to style: MGLStyle) {

        // 10: To show a point on the map, you can use an instance of MGLCircleStyleLayer. Create one with
        // a unique identifier and related source. Then configue it to represent the metro
        // stations with circles.
        let pointsLayer = MGLCircleStyleLayer(identifier: source.identifier + "-station", source: source)

        // 11: Use a predicates to filter the metro stations from the shape source. In current
        // example, metro stations have a "fclass" property equal to "subway_station".
        pointsLayer.predicate = NSPredicate(format: "fclass = 'subway_station'")
        pointsLayer.circleRadius = NSExpression(
            format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', 6, %@)",
            [12: 6, 18: 12]
        )
        pointsLayer.circleColor = NSExpression(forConstantValue: UIColor.red)
        pointsLayer.circleStrokeWidth = NSExpression(forConstantValue: 2)
        pointsLayer.circleStrokeColor = NSExpression(forConstantValue: UIColor.white)

        // 12: Finally add the circle layer to the style.
        style.addLayer(pointsLayer)
    }
}


