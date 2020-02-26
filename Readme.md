# Map.ir Map Kit

Map.ir Map Kit is an interactive map based on Mapbox framework, providing Map.ir tiles.

## Features
- Supports Swift and Objective-C
- Customizable map and gestures.
- Interface similar to Apple's MapKit.
- Support for Interface builder.
- Automatic switch to dark mode with sunset/sunrise ro when the system's theme updates.
- **All with Map.ir vector and raster tiles.**


## Example

To see the example application, first run `git clone https://github.com/map-ir/mapir-ios-maps-sdk` in terminal. Open `MapirMapKit.xcodeproj`. Build and run `Mapir MapKit Example` target. Every view controller demonstrates a feature of the map. More examples will be available soon. 


## Installation

### Cocoapods

Map.ir Map Kit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```bash
pod 'MapirMapKit' 
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

To integrate Map.ir Map Kit into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "map-ir/mapir-ios-maps-sdk"
```

Run `carthage update` to build the frameworks and drag the built `MapirLiveTracker.framework` and `Mapbox.framework` into your Xcode project. 

On your application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase” and add the following line:

```bash
/usr/local/bin/carthage copy-frameworks
```

Add `MapirMapKit.framework` and `Mapbox.framework` as input files:

```bash
$(SRCROOT)/Carthage/Build/iOS/MapirMapKit.framework
$(SRCROOT)/Carthage/Build/iOS/Mapbox.framework
$(SRCROOT)/Carthage/Build/iOS/MapboxMobileEvents.framework
```

See [Carthage Getting started Step 4, 5 and 6](https://github.com/Carthage/Carthage/blob/master/README.md#if-youre-building-for-ios-tvos-or-watchos) for more details.

## Usage
This SDK is compatible with both Swift and Objective-C programming languages, using iOS 9.0 or newer. 

first import Map.ir MapKit.

```swift
import MapirMapKit
```

```objective-c
#import <MapirMapKit/MapirMapKit.h>
```

In order to use Map.ir tiles, you need to specifiy you API key in your project's Info.plist file with `MAPIRAPIKey` (older versions used `MAPIRAccessToken` key It's still supported by the SDK but we recommend to update the key to `MAPIRAPIKey`).

```xml
<key>MapirAPIKey</key>
<string><YOUR_API_KEY></string>
```

Then use initializers for of `SHMapView` to create an instance of it. SHMapView is the subclass of [`MGLMapView`](https://docs.mapbox.com/ios/api/maps/5.5.0/Classes/MGLMapView.html) with Map.ir tiles. To receive updates related to the map, such as events about loading of the style, your should specify a delegate object for the map view, set the delegate class right after when you create the instance of `SHMapView`. To create instansiate `SHMapView` and specifying its `delegate` see code below:

```swift
class ViewController: UIViewController {

    var mapView: SHMapView!

    override func viewDidLoad() { 
        super.viewDidLoad()
        
        mapView = SHMapView(frame: view.bounds)
        mapView.delegate = self
    }
    ...
}

extension ViewController: SHMapViewDelegate {
    // Define delegate methods here.
}
```

**In your view controller's header file:**

```objective-c
@interface ViewController : UIViewController <SHMapViewDelegate>

@property (nonatomic, strong) SHMapView *mapView;

@end
```

**In your view controller's implementation file:**

```objective-c
@implementation

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mapView = [[SHMapView alloc] initWithFrame:self.view.bounds];
    [mapView setDelegate:self];
}

// Define delegate methods here.

@end
```

## Contributing

Contributions are very welcome. 🙌
