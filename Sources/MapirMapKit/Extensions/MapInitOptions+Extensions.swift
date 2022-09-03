import Foundation
import MapboxMaps

extension MapInitOptions {
    public static func mapirCompatible(
        resourceOptions: ResourceOptions = ResourceOptionsManager.default.resourceOptions,
        mapOptions: MapOptions = MapOptions(),
        cameraOptions: CameraOptions? = nil,
        styleURI: MapirStyleURI = .mapirLightStyle
    ) -> MapInitOptions {
        self.init(
            resourceOptions: resourceOptions,
            mapOptions: mapOptions,
            cameraOptions: cameraOptions,
            styleURI: StyleURI(styleURI)
        )
    }
}
