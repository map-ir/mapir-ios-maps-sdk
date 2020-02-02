//
//  SHAccountManagerTests.swift
//  MapirMapKitTests
//
//  Created by Alireza Asadi on 25/9/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

import XCTest
import MapirMapKit

class SHAccountManagerTests: XCTestCase {

    var sdkBundle: Bundle!
    var mapView: SHMapView!

    override func setUp() {
        sdkBundle = Bundle(for: SHAccountManager.self)
    }

    override func tearDown() {
        sdkBundle = nil
        mapView = nil
    }

//    func testLoadingAPIKey_LoadAPIKeyFromInfoPlist() {
//        // Given
//        let apiKey = "ey.youhavejustbegunreadingthesentenceyouhavejustfinishedreading"
//        mapView = SHMapView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//
//        // When
//        let sut = SHAccountManager.apiKey
//
//        // Then
//        XCTAssertEqual(sut, apiKey)
//    }

    func testLoadingAPIKey_loadAPIKeyFromMapViewInit() {
        // Given
        let apiKey = "ey.youhavejustbegunreadingthesentenceyouhavejustfinishedreading"
        mapView = SHMapView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), apiKey: apiKey)

        // When
        let sut = SHAccountManager.apiKey

        // Then
        XCTAssertEqual(sut, apiKey)
    }
}
