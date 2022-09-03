import Foundation

public final class MapirAccountManager {
    public static var shared: MapirAccountManager = .init()

    public private(set) var accessToken: String
    public private(set) var isAuthorized: Bool

    public static let unauthorizedNotification: Notification.Name = .init("UnauthorizedAPIKeyNotification")

    private init() {
        self.accessToken = MapirAccountManager.accessToken()
        self.isAuthorized = true
    }

    func receivedUnauthorizedStatusCode() {
        guard isAuthorized else { return }
        isAuthorized = false
        
        NotificationCenter.default.post(name: MapirAccountManager.unauthorizedNotification, object: nil)

        let notice = """
            Your Map.ir API key is not valid or you have reached the daily limit of your API key.
            See https://map.ir/unauthorized for more information.
            """

        print(notice)
    }

    private static func accessToken() -> String {
        (Bundle.main.object(forInfoDictionaryKey: "MapirAPIKey")! as! String).trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
