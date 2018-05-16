import Foundation

extension String {
    public func appendingPathComponent(_ pathComponent: String) -> String {
        return (self as NSString).appendingPathComponent(pathComponent)
    }

    public func appendingPathExtension(_ fileExtension: String) -> String? {
        return (self as NSString).appendingPathExtension(fileExtension)
    }

    public func leftPadding(toLength: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return String(self.suffix(toLength))
        }
    }
}
