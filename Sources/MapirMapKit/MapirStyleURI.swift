import Foundation

public struct MapirStyleURI: Hashable, RawRepresentable, CaseIterable {
    /// Map.ir's default light vector style. It is also called "Verna" style.
    ///
    /// Map.ir default style is the main vector-based map style created by Map.ir team.
    public static let mapirLightStyle = MapirStyleURI(rawValue: "https://map.ir/vector/styles/main/main_mobile_style.json")!

    /// Map.ir's default vector style with minimal amount of POI icons on the map. It is also called "Isatis" style.
    ///
    /// Map.ir default style is the main vector-based map style created by Map.ir team.
    public static let mapirMinimalLightStyle = MapirStyleURI(rawValue: "https://map.ir/vector/styles/main/mapir-style-min-poi.json")!

    /// Map.ir default dark vector style. It is also called "Carmania" style.
    ///
    /// Map.ir default style is the main vector-based map style created by Map.ir team.
    public static let mapirDarkStyle = MapirStyleURI(rawValue: "https://map.ir/vector/styles/main/mapir-style-dark.json")!

    // TODO: Add Mapir Raster Style.

    public static var allCases: [MapirStyleURI] = [.mapirLightStyle, .mapirDarkStyle, .mapirMinimalLightStyle]

    public var rawValue: String

    public init?(rawValue: String) {
        self.rawValue = rawValue
    }
}
