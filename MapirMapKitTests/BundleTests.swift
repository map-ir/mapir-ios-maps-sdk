//
//  BundleTests.swift
//  MapirMapKitTests
//
//  Created by Alireza Asadi on 25/9/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

import XCTest
import MapirMapKit

class BundleTests: XCTestCase {

    var sdkBundle: Bundle!

    override func setUp() {
        sdkBundle = Bundle(for: SHMapView.self)
    }

    override func tearDown() {
        sdkBundle = nil
    }

    func testBundleAvailablity_bundleNotBeNil() {
        XCTAssertNotNil(sdkBundle)
    }

    func testBundleIncludeAllAssets_assetsAreAvailable() {
        XCTAssertNotNil(sdkBundle)

        XCTAssertNotNil(sdkBundle.path(forResource: "Shiveh", ofType: "json"))
        XCTAssertNotNil(UIImage(named: "map-logo-light", in: sdkBundle, compatibleWith: nil))
        XCTAssertNotNil(UIImage(named: "map-logo-dark", in: sdkBundle, compatibleWith: nil))
        XCTAssertNotNil(UIImage(named: "mapir-default-marker", in: sdkBundle, compatibleWith: nil))
        XCTAssertNotNil(UIImage(named: "compass-light", in: sdkBundle, compatibleWith: nil))
        XCTAssertNotNil(UIImage(named: "compass-dark", in: sdkBundle, compatibleWith: nil))
    }

}
