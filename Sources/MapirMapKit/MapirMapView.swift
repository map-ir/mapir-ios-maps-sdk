import Foundation
import MapboxMaps
import MapboxCommon

public class MapirMapView: MapView {
    @available(iOSApplicationExtension, unavailable)
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @available(iOS 13.0, *)
    public override init(
        frame: CGRect,
        mapInitOptions: MapInitOptions = .mapirCompatible(),
        urlOpener: AttributionURLOpener
    ) {
        super.init(
            frame: frame,
            mapInitOptions: mapInitOptions,
            urlOpener: urlOpener
        )
    }

    @available(iOS, deprecated: 13, message: "Use init(frame:mapInitOptions:urlOpener:) instead")
    public override init(
        frame: CGRect,
        mapInitOptions: MapInitOptions = .mapirCompatible(),
        orientationProvider: InterfaceOrientationProvider,
        urlOpener: AttributionURLOpener
    ) {
        super.init(
            frame: frame,
            mapInitOptions: mapInitOptions,
            orientationProvider: orientationProvider,
            urlOpener: urlOpener
        )
    }
}
