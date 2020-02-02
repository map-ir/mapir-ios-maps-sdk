//
//  ViewController.swift
//  Mapir MapKit Example
//
//  Created by Alireza Asadi on 19/9/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

import UIKit
import MapirMapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: SHMapView!
    @IBOutlet weak var styleSegmentedControl: UISegmentedControl!

    var selectedFeatureIndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupObservers()

        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 35.732592, longitude: 51.422554)
        mapView.showsUserLocation = true
        mapView.zoomLevel = 14

        mapView.delegate = self
    }

    private func setupObservers() {
        
        NotificationCenter.default.addObserver(forName: kSelectedFeatureUpdateNotificationName, object: nil, queue: .main) { [weak self] (notification) in
            guard let self = self else { return }
            if let indexPath = notification.object as? IndexPath {
                self.selectedFeatureIndexPath = indexPath
            }
        }

        NotificationCenter.default.addObserver(forName: SHAccountManager.unauthorizedNotification, object: nil, queue: nil) { (notification) in
            if let error = notification.object as? LocalizedError {
                print("""
                    {
                        Error:   \(error.errorDescription ?? "")
                        Reason:  \(error.failureReason ?? "")
                    }
                    """)
            }
        }
    }
    
    @IBAction func segmentSwitched(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.styleURL = SHStyle.vernaStyleURL
            updateUserInterfaceStyle(to: .light)
        case 1:
            mapView.styleURL = SHStyle.hyrcaniaStyleURL
            updateUserInterfaceStyle(to: .light)
        case 2:
            mapView.styleURL = SHStyle.isatisStyleURL
            updateUserInterfaceStyle(to: .light)
        case 3:
            mapView.styleURL = SHStyle.carmaniaStyleURL
            updateUserInterfaceStyle(to: .dark)
        default:
            mapView.styleURL = SHStyle.vernaStyleURL
            updateUserInterfaceStyle(to: .light)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: FeaturesTableViewController.self) {
            let destination = segue.destination as! FeaturesTableViewController
            destination.mapView = mapView
            destination.selectedIndexPath = selectedFeatureIndexPath
        }
    }

    func updateUserInterfaceStyle(to style: UIUserInterfaceStyle) {
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = style
        }
    }
}

extension MapViewController: MGLMapViewDelegate {
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        print("Map Loaded successfully.")
    }

    func mapViewDidFailLoadingMap(_ mapView: MGLMapView, withError error: Error) {
        print("Loading map failed with error.")
        print("Message: \(error)")
    }
}
