//
//  SHStyle.swift
//  MapirMapKitTests
//
//  Created by Alireza Asadi on 25/9/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

import XCTest
import MapirMapKit

class SHStyleTests: XCTestCase {

    let sdkBundle = Bundle(for: SHStyle.self)

    func testRasterStyleURL_returnProperURL() {
        let sut = SHStyle.hyrcaniaStyleURL
        let correntURLString = sdkBundle.path(forResource: "Shiveh", ofType: "json")!
        XCTAssertEqual(sut.absoluteString, correntURLString)
    }

    func testDefaultStyleURL_returnProperURL() {
        let sut = SHStyle.vernaStyleURL
        let correntURLString = "https://map.ir/vector/styles/main/main_mobile_style.json"
        XCTAssertEqual(sut.absoluteString, correntURLString)
    }

    func testDefaultWithLessPOIStyleURL_returnProperURL() {
        let sut = SHStyle.isatisStyleURL
        let correntURLString = "https://map.ir/vector/styles/main/mapir-style-min-poi.json"
        XCTAssertEqual(sut.absoluteString, correntURLString)
    }

    func testDarkStyleURL_returnProperURL() {
        let sut = SHStyle.carmaniaStyleURL
        let correntURLString = "https://map.ir/vector/styles/main/mapir-style-dark.json"
        XCTAssertEqual(sut.absoluteString, correntURLString)
    }

}
