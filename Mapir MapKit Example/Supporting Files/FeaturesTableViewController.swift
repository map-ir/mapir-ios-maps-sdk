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
            description: "Initilizing a map view using stroyboard.",
            iconName: "selection.pin.in.out",
            associatedViewController: StoryboardMapViewController.self
        ),
        Feature(
            title: "SHMapView with code",
            description: "Creating a map view using code.",
            iconName: "chevron.left.slash.chevron.right",
            associatedViewController: CodeMapViewController.self
        ),
    ],
    [
        Feature(
            title: "Point Annotations",
            description: "Showing different places using point annotations (aka. markers) on the map.",
            iconName: "mappin.and.ellipse",
            associatedViewController: AnnotationExampleViewController.self
        ),
        Feature(
            title: "Polylines",
            description: "Showing a polyline annotation and customizing its appearance.",
            iconName: "rectangle",
            associatedViewController: PolylineExampleViewController.self
        ),
        Feature(
            title: "Polygon",
            description: "Showing a polygon annotation and customizing its appearance.",
            iconName: "scribble",
            associatedViewController: PolygonExampleViewController.self
        ),
    ],
    [
        Feature(
            title: "Multiple Shapes",
            description: "Showing Shiraz metro line and stations using MGLShapeSource and MGLStyleLayer, using GeoJSON data.",
            iconName: "rectangle.3.offgrid",
            associatedViewController: MultipleShapesExampleViewController.self
        ),
        Feature(
            title: "Multiple Images",
            description: "Showing some of Iran peaks on the map using MGLShapeSource and MGLSymbolStyleLayer, using GeoJSON data.",
            iconName: "photo.fill.on.rectangle.fill",
            associatedViewController: MultipleImagesExampleViewController.self
        ),
    ],
    [
        Feature(
            title: "Annotation View",
            description: "Customzing annotation views used to show point annotations on the map.",
            iconName: "pin",
            associatedViewController: AnnotationViewExampleViewController.self
        ),
        Feature(
            title: "Draggable Annotation View",
            description: "Creating draggable annotation views.",
            iconName: "hand.draw",
            associatedViewController: DraggableAnnotationViewExampleViewController.self
        ),
    ],
    [
        Feature(
            title: "Custom Callout View",
            description: "Creating and using a fully customized callout view rather than using the default callout view.",
            iconName: "bubble.middle.bottom",
            associatedViewController: CustomCalloutViewExampleViewController.self
        ),
    ],
    [
        Feature(
            title: "Auto Dark Mode",
            description: "Using dark mode based on sunrise and sunset time.",
            iconName: "sun.haze",
            associatedViewController: AutoDarkModeExampleViewController.self
        ),
        Feature(
            title: "Auto Dark Mode With iOS",
            description: "Updating map style based on iOS setting of dark mode and light mode.",
            iconName: "circle.lefthalf.fill",
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
            cell.detailTextLabel?.numberOfLines = 0
            cell.imageView?.image = UIImage(systemName: selectedFeature.iconName ?? "")
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
            target = selectedFeature.associatedViewController.init()
        }
        target.navigationItem.title = selectedFeature.title
        target.navigationItem.backBarButtonItem?.title = "All Examples"
        navigationController?.pushViewController(target, animated: true)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let titles = [
            "Map View",
            "Annotations",
            "Shape Sources & Style Layers",
            "Annotation Views",
            "Custom Callouts",
            "Auto Dark Mode"
        ]

        return titles[section]
    }
}
