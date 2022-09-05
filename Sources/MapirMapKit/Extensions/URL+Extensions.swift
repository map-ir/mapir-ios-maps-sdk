import Foundation

extension URL {
    func isHostedByMapir() -> Bool {
        host?.range(of: #"^([a-zA-Z0-9-]+\.)*map.ir$"#, options: .regularExpression) != nil
    }
}
