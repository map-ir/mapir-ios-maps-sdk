//
//  MapirMapKitTests.swift
//  MapirMapKitTests
//
//  Created by Alireza Asadi on 25/9/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

import XCTest
@testable import MapirMapKit

class SHMapViewTests: XCTestCase {

    var mapView: SHMapView!
    let sdkBundle = Bundle(for: SHMapView.self)

    override func setUp() {
        super.setUp()
        SHAccountManager.apiKey = "ey.testapikey"
        mapView = SHMapView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
    }

    override func tearDown() {
        SHAccountManager.apiKey = nil
        mapView = nil
        super.tearDown()
    }

    // Naming: test<StateUnderTest>_<ExpectedBehavior>

    func testlogoViewLoading_LoadsMapirLogoImage() {
        let mapirLogoImage = UIImage(named: "map-logo-light", in: sdkBundle, compatibleWith: nil)
        let sut = mapView.logoView.image
        XCTAssertEqual(sut, mapirLogoImage)
    }

    func testLogoViewResize_resizesTo() {
        let sut = mapView.logoView
        let correctSize = CGSize(width: 104, height: 37)
        XCTAssertEqual(sut.frame.size, correctSize)
    }

    func testAttributionLabel_AttributionLabelIsCreated() {
        let sut = mapView.attributionLabel
        XCTAssertNotNil(sut)
    }

    func testAttributionLabelText_TextMustShowMapirAndOpenStreetMapAttribution() {
        let sut = mapView.attributionLabel
        XCTAssertEqual(sut.text, "© Map © OpenSreetMap")
        XCTAssertFalse(sut.isHidden)
        XCTAssertTrue(sut.font.pointSize > 8)
    }

    func testInit_loadsMapirDefaultVectorStyle() {
        
    }

}
