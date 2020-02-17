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
        Feature(
            title: "SHMapView with storyboard",
            description: "Initilizes a map view using stroyboard.",
            associatedViewController: StoryboardMapViewController.self
        ),
        Feature(
            title: "SHMapView with code",
            description: "Creates a map view using code.",
            associatedViewController: CodeMapViewController.self
        ),
    ],
    [
        Feature(
            title: "Point Annotations",
            associatedViewController: AnnotationExampleViewController.self
        ),
        Feature(
            title: "Polylines",
            associatedViewController: PolylineExampleViewController.self
        ),
        Feature(
            title: "Polygon",
            associatedViewController: PolygonExampleViewController.self
        ),
    ],
    [
        Feature(
            title: "Annotation View",
            associatedViewController: AnnotationViewExampleViewController.self
        ),
        Feature(
            title: "Draggable Annotation View",
            associatedViewController: DraggableAnnotationViewExampleViewController.self
        ),
    ],
    [
        Feature(
            title: "Custom Callout View",
            associatedViewController: CustomCalloutViewExampleViewController.self
        ),
    ],
    [
        Feature(
            title: "Auto Dark Mode",
            description: "Dark mode based on sunrise and sunset time.",
            associatedViewController: AutoDarkModeExampleViewController.self
        ),
        Feature(
            title: "Auto Dark Mode With iOS",
            description: "Updates map style based on iOS setting of dark mode and light mode.",
            associatedViewController: AutoDarkModeUpdateWithOSExampleViewController.self
        )
    ],
]


class FeaturesTableViewController: UITableViewController {

    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return features.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let selectedFeature = features[indexPath.section][indexPath.row]

        let cell: UITableViewCell
        if let desc = selectedFeature.description {
            cell = tableView.dequeueReusableCell(withIdentifier: "DetailedFeatureCell", for: indexPath)
            cell.textLabel?.text = selectedFeature.title
            cell.detailTextLabel?.text = desc
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "DefaultFeatureCell", for: indexPath)
            cell.textLabel?.text = selectedFeature.title
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedFeature = features[indexPath.section][indexPath.row]
        let target: UIViewController

        if selectedFeature == features.first?.first {
            if let storyboardVC = storyboard?.instantiateViewController(withIdentifier: "StoryboardCreatedVC") {
                target = storyboardVC
            } else {
                return
            }
        } else {
            let vcType = selectedFeature.associatedViewController
            if vcType == CodeMapViewController.self {
                target = CodeMapViewController()
            } else if vcType == AnnotationExampleViewController.self {
                target = AnnotationExampleViewController()
            } else if vcType == PolylineExampleViewController.self {
                target = PolylineExampleViewController()
            } else if vcType == PolygonExampleViewController.self {
                target = PolygonExampleViewController()
            } else if vcType == AutoDarkModeExampleViewController.self {
                target = AutoDarkModeExampleViewController()
            } else if vcType == AutoDarkModeUpdateWithOSExampleViewController.self {
                target = AutoDarkModeUpdateWithOSExampleViewController()
            } else if vcType == AnnotationViewExampleViewController.self {
                target = AnnotationViewExampleViewController()
            } else if vcType == DraggableAnnotationViewExampleViewController.self {
                target = DraggableAnnotationViewExampleViewController()
            } else if vcType == CustomCalloutViewExampleViewController.self {
                target = CustomCalloutViewExampleViewController()
            } else {
                return
            }
        }

        target.navigationItem.title = selectedFeature.title
        target.navigationItem.backBarButtonItem?.title = "All Examples"
        navigationController?.pushViewController(target, animated: true)
    }
}
