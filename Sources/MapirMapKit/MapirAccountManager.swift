import Foundation

public final class MapirAccountManager {
    public static var shared: MapirAccountManager = .init()

    public private(set) var apiKey: String?
    public private(set) var isAuthorized: Bool

    public static let unauthorizedNotification: Notification.Name = .init("UnauthorizedAPIKeyNotification")

    private init() {
        self.apiKey = nil
        self.isAuthorized = false
    }

    public func set(apiKey: String) {
        self.apiKey = apiKey
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
}
