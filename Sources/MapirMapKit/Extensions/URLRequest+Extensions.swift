import Foundation

extension URLRequest {
    mutating func addMapirSpecificHeaders() {
        setValue(MapirAccountManager.shared.apiKey, forHTTPHeaderField: "x-api-key")
        setValue(URLRequest.sdkIdentifer, forHTTPHeaderField: "MapIr-SDK")
        setValue(URLRequest.userAgent, forHTTPHeaderField: "User-Agent")
    }

    private static let userAgent: String = {
        var components: [String] = []
        components.append(appBundleInfo)
        components.append(sdkBundleInfo)
        components.append("\(systemName)/\(systemVersion)")
        if let arch = systemArch {
            components.append("(\(arch))")
        }

        return components.joined(separator: " ")
    }()

    private static let sdkIdentifer: String = {
        var components: [String] = []

        let osName = "\(systemName)/\(systemVersion)" + (systemArch == nil ? "" : "(\(systemArch!))")
        components.append(osName)
        components.append(sdkBundleInfo)
        components.append(appBundleInfo)

        return components.joined(separator: "-")
    }()

    private static let appBundleInfo: String = {
        let bundle = Bundle.main
        let appName: String? = Bundle.main.value(for: "CFBundleName")
        let appBundleID: String? = Bundle.main.value(for: "CFBundleIdentifier")
        let appBuild: String? = Bundle.main.value(for: "CFBundleShortVersionString")
        if let name = appName ?? appBundleID, let appBuild = appBuild {
            return "\(name)/\(appBuild)"
        } else {
            return ProcessInfo.processInfo.processName
        }
    }()

    private static let sdkBundleInfo: String = {
        let sdkName: String = "MapirMapKit"
        let sdkBuild: String = MapirMapKit.sdkVersion
        return "\(sdkName)/\(sdkBuild)"
    }()

    private static let systemName: String = {
        var systemName = "Darwin"
#if TARGET_OS_IPHONE
        systemName = "iOS"
#elseif TARGET_OS_MAC
        systemName = "macOS"
#elseif TARGET_OS_WATCH
        systemName = "watchOS"
#elseif TARGET_OS_TV
        systemName = "tvOS"
#endif

#if TARGET_OS_SIMULATOR
        systemName = "\(systemName) Simulator"
#endif
        return systemName
    }()

    private static let systemVersion: String = {
        let osVersion = ProcessInfo.processInfo.operatingSystemVersion
        return "\(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)"
    }()

    private static let systemArch: String? = {
#if TARGET_CPU_X86
        "x86"
#elseif TARGET_CPU_X86_64
        "x86_64"
#elseif TARGET_CPU_ARM
        "arm"
#elseif TARGET_CPU_ARM64
        "arm64"
#else
        nil
#endif
    }()
}
