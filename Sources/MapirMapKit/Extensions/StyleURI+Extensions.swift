import Foundation
import MapboxMaps

extension StyleURI {
    init(_ mapirStyleURI: MapirStyleURI) {
        self.init(rawValue: mapirStyleURI.rawValue)!
    }
}
