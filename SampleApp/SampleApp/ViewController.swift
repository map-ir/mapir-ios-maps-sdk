//
//  ViewController.swift
//  SampleApp
//
//  Created by Alireza Asadi on 15/6/1401 AP.
//

import UIKit
import MapirMapKit

struct MapirAttributionURLOpener: AttributionURLOpener {
    func openAttributionURL(_ url: URL) {}
}

class ViewController: UIViewController {
    var mapView: MapirMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MapirMapView(frame: view.bounds, mapInitOptions: .mapirCompatible(), urlOpener: MapirAttributionURLOpener())
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.view.addSubview(mapView)
    }
}

