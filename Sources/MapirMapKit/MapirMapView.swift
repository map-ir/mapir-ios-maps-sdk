import Foundation
import MapboxMaps
import MapboxCommon

public class MapirMapView: MapView {
    private weak var attributionView: AttributionView!
    private weak var logoView: UIImageView!

    @available(iOSApplicationExtension, unavailable)
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
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
        commonInit()
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
        commonInit()
    }

    private func commonInit() {
        replaceMapboxComponents()
//        mapboxMap.onEvery(event: .styleLoaded) { [weak self] event in
//            if let uri = self?.mapboxMap.style.uri?.rawValue,
//               MapirStyleURI.allCases.map(\.rawValue).contains(uri)
//            {
//                TODO: Update style of the map based on dark or light appearance. (here)
//            }
//        }
    }

    private func replaceMapboxComponents() {
        updateLogo()
        updateAttribution()
    }

    private func updateAttribution() {
        let attributionContainer = ornaments.attributionButton
        attributionContainer.layer.opacity = 0

        let attribution = AttributionView()
        addSubview(attribution)

        attribution.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            attribution.bottomAnchor.constraint(equalTo: attributionContainer.bottomAnchor),
            attribution.trailingAnchor.constraint(equalTo: attributionContainer.trailingAnchor),
        ])

        self.attributionView = attribution
    }

    private func updateLogo() {
        let logoContainer = ornaments.logoView
        logoContainer.layer.opacity = 0

        let logo: UIImageView
        if #available(iOS 12.0, *) {
            logo = UIImageView(image: UIImage.logo(.light))
        } else {
            logo = UIImageView(image: UIImage.logo)
        }

        logo.contentMode = .scaleAspectFit
        addSubview(logo)

        logo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logo.bottomAnchor.constraint(equalTo: logoContainer.bottomAnchor),
            logo.topAnchor.constraint(equalTo: logoContainer.topAnchor),
            logo.leadingAnchor.constraint(equalTo: logoContainer.leadingAnchor),
        ])

        self.logoView = logo
    }
}

