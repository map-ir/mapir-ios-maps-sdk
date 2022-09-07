@_exported import MapboxMaps

public enum MapirMapKit {
    static var sdkVersion: String { "4.0.0" }

    public static func registerHTTPService() {
        HttpServiceFactory.setUserDefinedForCustom(MapirHTTPService())
    }
}
