import Foundation

public class JsonParser {
    public static func decode<T: Decodable>(_ data: Data) -> Result<T> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let result = try decoder.decode(T.self, from: data)
            return .success(result)
        } catch {
            return .error(error)
        }
    }
}
