//
//  FeaturesTableViewController.swift
//  Mapir MapKit Example
//
//  Created by Alireza Asadi on 23/9/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

import UIKit
import MapirMapKit

let features: [[Feature]] = [
    [
        Feature(title: "Show Clean Map") { (mapView) in
            mapView.reloadStyle(nil)
        }
    ],
    [
        Feature(title: "Show Annotations") { (mapView) in
            let places: [CLLocationCoordinate2D] = [
                CLLocationCoordinate2D(latitude: 35.70444254723662, longitude: 51.40929193108604),
                CLLocationCoordinate2D(latitude: 35.70067877695351, longitude: 51.40572995751427),
                CLLocationCoordinate2D(latitude: 35.70437284940166, longitude: 51.39452905266808),
                CLLocationCoordinate2D(latitude: 35.71165594362492, longitude: 51.39229745476768)
            ]

            var annotations: [MGLPointAnnotation] = []
            for coordinates in places {
                let newAnnotation = MGLPointAnnotation()
                newAnnotation.coordinate = coordinates
                newAnnotation.title = "\(coordinates.latitude), \(coordinates.longitude)"
                annotations.append(newAnnotation)
            }
            mapView.addAnnotations(annotations)

            let center = CLLocationCoordinate2D(latitude: 35.706219821440236, longitude: 51.400794692926866)
            mapView.setCenter(center, zoomLevel: 13, animated: false)
        },
        Feature(title: "Show Polyline") { (mapView) in
            let tehranMetroLine1 = [
                CLLocationCoordinate2D(latitude: 35.80507252158394, longitude: 51.43392446872894),
                CLLocationCoordinate2D(latitude: 35.79407342427046, longitude: 51.434439452859806),
                CLLocationCoordinate2D(latitude: 35.784465371936214, longitude: 51.43581274387543),
                CLLocationCoordinate2D(latitude: 35.77443833984296, longitude: 51.43684271213715),
                CLLocationCoordinate2D(latitude: 35.764688624064064, longitude: 51.443194183084415),
                CLLocationCoordinate2D(latitude: 35.76064910596281, longitude: 51.43083456394379),
                CLLocationCoordinate2D(latitude: 35.7557735523341, longitude: 51.42619970676605),
                CLLocationCoordinate2D(latitude: 35.7485293210029, longitude: 51.426028045389096),
                CLLocationCoordinate2D(latitude: 35.73961243877511, longitude: 51.42654302951996),
                CLLocationCoordinate2D(latitude: 35.73083390736887, longitude: 51.4256847226352)
            ]

            let polyline = MGLPolyline(coordinates: tehranMetroLine1, count: UInt(tehranMetroLine1.count))
            mapView.addAnnotation(polyline)

            let center = CLLocationCoordinate2D(latitude: 35.764688624064064, longitude: 51.443194183084415)
            mapView.setCenter(center, zoomLevel: 12, animated: false)
        },
        Feature(title: "Show Polygon") { (mapView) in
            let coordinates: [CLLocationCoordinate2D] = [
                CLLocationCoordinate2D(latitude: 35.706978535579, longitude: 51.39571666717529),
                CLLocationCoordinate2D(latitude: 35.70598536727269, longitude: 51.392165422439575),
                CLLocationCoordinate2D(latitude: 35.7011674541968, longitude: 51.39430046081543),
                CLLocationCoordinate2D(latitude: 35.70124586740935, longitude: 51.398216485977166)
            ]

            let polygon = MGLPolygon(coordinates: coordinates, count: UInt(coordinates.count))
            mapView.addAnnotation(polygon)

            let center = CLLocationCoordinate2D(latitude: 35.704007705813055, longitude: 51.3951051235199)
            mapView.setCenter(center, zoomLevel: 15, animated: false)
        }
    ],
    [
        Feature(
            title: "Auto Dark Mode",
            description: "Dark mode based on sunrise and sunset time."
        ) { (mapView) in
            mapView.autoDarkMode = .updateAutomatically
        },
        Feature(
            title: "Auto Dark Mode With iOS",
            description: "Updates map style based on iOS setting of dark mode and light mode."
        ) { (mapView) in
            mapView.autoDarkMode = .updateWithOS
        }
    ]
]

let kSelectedFeatureUpdateNotificationName = Notification.Name("kSelectedFeatureUpdateNotification")

class FeaturesTableViewController: UITableViewController {

    weak var mapView: SHMapView!
    var selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return features.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultFeatureCell", for: indexPath)
        let selectedFeature = feature(at: indexPath)

        cell.textLabel?.text = selectedFeature.title
        cell.detailTextLabel?.text = selectedFeature.description
        cell.accessoryType = .none
        if indexPath == selectedIndexPath {
            cell.accessoryType = .checkmark
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let currentCheckedRow = tableView.cellForRow(at: selectedIndexPath)
        currentCheckedRow?.accessoryType = .none

        let newCheckedRow = tableView.cellForRow(at: indexPath)
        newCheckedRow?.accessoryType = .checkmark

        selectedIndexPath = indexPath
        let notification = Notification(name: kSelectedFeatureUpdateNotificationName,
                                        object: selectedIndexPath,
                                        userInfo: nil)

        NotificationCenter.default.post(notification)

        let feature = self.feature(at: indexPath)
        self.cleanUpMapView()
        feature.task?(mapView)
        self.dismiss(animated: true)
    }
}

extension FeaturesTableViewController {
    func cleanUpMapView() {
        mapView.logoView.isHidden = false
        mapView.attributionLabel.isHidden = false

//        let center = CLLocationCoordinate2D(latitude: 35.732592, longitude: 51.422554)
//        mapView.setCenter(center, zoomLevel: 10, animated: true)

        if let allAnnots = mapView.annotations {
            mapView.removeAnnotations(allAnnots)
        }

        mapView.autoDarkMode = .off
    }
}


extension FeaturesTableViewController {
    func feature(at indexPath: IndexPath) -> Feature { features[indexPath.section][indexPath.row] }
}
