Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.name         = "MapirMapKit"
  spec.version      = "3.2.0"
  spec.summary      = "Map.ir Maps SDK for iOS based on mapbox-gl-native."

  spec.description  = <<-DESC
                         MapirMapKit is Map.ir Maps SDK for iOS based on mapbox-gl-native.
                         It offers interactive map with default gestures to manipulate it,
                         all with Map.ir tiles and datasets.
                   DESC

  spec.homepage     = "https://support.map.ir/developers/ios/"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.license      = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.authors            = { "Map.ir" => "info@map.ir",
                              "Alireza Asadi" => "alireza.asadi.36@gmail.com" }

  spec.social_media_url   = "https://twitter.com/map_ir_Official"


  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.platform     = :ios, "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.source       = { :git => "https://github.com/map-ir/mapir-ios-maps-sdk.git", :tag => "#{spec.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.source_files        = "MapirMapKit/**/*.{h,m}"

  spec.public_header_files = "MapirMapKit/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.resources = 'MapirMapKit/Resources/*'


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.requires_arc = true

  spec.dependency "Mapbox-iOS-SDK", "~> 5.9.0"

end
