# Map.ir Map Kit

Map.ir Map Kit is an interactive map based on Mapbox framework, providing Map.ir tiles.

## Features
- Supports Swift and Objective-C
- Customizable map and gestures.
- Support for Interface builder.
- **All with Map.ir vector tiles.**


## Example

To see the example application, first clone the project using `git clone https://github.com/map-ir/mapir-ios-maps-sdk` in terminal.
Open `SampleApp/SampleApp.xcodeproj`. Build and run `SampleApp` target.

You need to put your Map.ir API key in a file at your home directory named `.mapir` or just enter it in SampleApp's `AppDelegate.swift` in `application(_:didFinishLaunchingWithOptions:)` using the following code:

```swift
MapirAccountManager.shared.set(apiKey: "eyJ0eXAiO...")
``` 

## Installation

### Swift Package Manager

> **Note**
> Since Map.ir maps SDK is based on Mapbox's SDK, you need to follow [Mapbox's Instruction](https://docs.mapbox.com/ios/maps/guides/install/#configure-credentials) to be able to install the SDKs. 

Map.ir Map Kit is available through [Swift Package Manager](https://www.swift.org/package-manager/). To install
it, simply add the following line to your dependencies of your Package.swift file:

```swift
.package(name: "MapirMapKit", url: "https://github.com/map-ir/mapir-ios-maps-sdk.git", from: "2.0.0"),
```

Or, if you are using Xcode, Click on "File > Add Packages" enter the following URL in the search box. 
then set the version to `from: 4.0.0`. 

```
https://github.com/map-ir/mapir-ios-maps-sdk.git
``` 

## Usage
This SDK is compatible with both Swift and Objective-C programming languages, using iOS 9.0 or newer. 

first import Map.ir MapKit.

```swift
import MapirMapKit
```

Then use initializers for of `MapirMapView` to create an instance of it. `MapirMapView` is the subclass of [`MapView`](https://docs.mapbox.com/ios/maps/api/10.7.0/Classes/MapView.html#/MapView) with Map.ir tiles.

```swift
struct MapirAttributionURLOpener: AttributionURLOpener {
    func openAttributionURL(_ url: URL) {}
}

class ViewController: UIViewController {
    var mapView: MapirMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MapirMapView(frame: view.bounds, mapInitOptions: .mapirCompatible(), urlOpener: MapirAttributionURLOpener())
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(mapView)
    }
    
    ...
}
```

## Contributing

Contributions are very welcome. 🙌
