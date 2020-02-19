//
//  MultipleImagesExampleViewController.swift
//  Mapir MapKit Example
//
//  Created by Alireza Asadi on 29/11/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

import UIKit
import MapirMapKit

class MultipleImagesExampleViewController: UIViewController, MGLMapViewDelegate {

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

        style.setImage(UIImage(named: "low")!, forName: "low")
        style.setImage(UIImage(named: "medium")!, forName: "medium")
        style.setImage(UIImage(named: "high")!, forName: "high")
        style.setImage(UIImage(named: "very high")!, forName: "very_high")

        // 2: There is a GeoJSON file in the application bundle which contains information
        // about Shiraz metro line 1 and its stations. In this example we will show the
        // line and stations on the map.
        guard let peaksOfIranGeoJSON = Bundle.main.path(forResource: "Peaks", ofType: "geojson") else { return }
        let url = URL(fileURLWithPath: peaksOfIranGeoJSON)

        // 3: Create a shape source with a unique and declarative identifier, a url (of GeoJSON file) and
        // dictionary of options as you want.
        let shapeSource = MGLShapeSource(identifier: "iran-peaks", url: url)

        // 4: Add the shape source to the map's style.
        style.addSource(shapeSource)

        // 5: Create style layer for the shape source.
        addSymbols(from: shapeSource, to: style)

        // Recenters the map view to see all of Iran.
        let center = CLLocationCoordinate2D(latitude: 32.778038, longitude: 53.712158)
        mapView.setCenter(center, zoomLevel: 4, animated: true)
    }

    // MARK: - Creating Layers

    func addSymbols(from source: MGLShapeSource, to style: MGLStyle) {

        // 6: Create a symbol layer for the source with a unique identifier
        let symbolLayer = MGLSymbolStyleLayer(identifier: source.identifier + "-symbols", source: source)

        let stops = [
            3000: NSExpression(forConstantValue: "low"),
            4000: NSExpression(forConstantValue: "medium"),
            4500: NSExpression(forConstantValue: "high"),
            5000: NSExpression(forConstantValue: "very_high")
        ]

        // 7: Use expressions to assign images of each symbol based on their elevation
        // data.
        symbolLayer.iconImageName = NSExpression(
            format: "mgl_step:from:stops:(elevation, %@, %@)",
            NSExpression(forConstantValue: "low"),
            stops
        )

        // 8: Use expressions to append the elevation of the peak to it's name, based on the source data.
        symbolLayer.text = NSExpression(
            format: "mgl_join:({ %@, '\\n', %@, ' متر' })",
            NSExpression(forKeyPath: "name"),
            NSExpression(format: "CAST(%@, 'NSString')", NSExpression(forKeyPath: "elevation"))
        )

        // 9: Customize other properties of the symbol layer as you wish.
        symbolLayer.textFontNames = NSExpression(forConstantValue: ["IranSans-Noto"])
        symbolLayer.textFontSize = NSExpression(forConstantValue: 9)
        symbolLayer.textAllowsOverlap = NSExpression(forConstantValue: true)
        symbolLayer.textColor = NSExpression(forConstantValue: UIColor.black)
        symbolLayer.textAnchor = NSExpression(forConstantValue: "top")
        symbolLayer.textTranslation = NSExpression(forConstantValue: NSValue(cgVector: CGVector(dx: 0, dy: 12)))

        // 10: Finally add the layer to the style.
        style.addLayer(symbolLayer)

    }

}
