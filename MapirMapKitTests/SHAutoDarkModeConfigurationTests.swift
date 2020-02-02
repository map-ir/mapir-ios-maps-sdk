//
//  SHAutoDarkModeConfiguration.swift
//  MapirMapKitTests
//
//  Created by Alireza Asadi on 1/11/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

import XCTest
@testable import MapirMapKit

class SHAutoDarkModeConfigurationTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitializer_initializesAPorperConfigClass() {
        let lightStyleURL = URL(string: "https://map.light")!
        let darkStyleURL = URL(string: "https://map.dark")!
        let location = CLLocation(latitude: 10.0, longitude: 20.0)
        let sut = SHAutoDarkModeConfiguration(lightStyleURL: lightStyleURL,
                                              darkStyleURL: darkStyleURL,
                                              location: location)

        XCTAssertEqual(sut.lightStyleURL, lightStyleURL)
        XCTAssertEqual(sut.darkStyleURL, darkStyleURL)
        XCTAssertEqual(sut.location, location)
    }
}
