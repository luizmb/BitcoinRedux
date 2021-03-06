import Foundation

extension URLRequest {
    public static func createRequest(url urlString: String,
                                     httpMethod: String,
                                     urlParams: [String: String] = [:]) -> URLRequest {
        let urlSuffix = urlParams.isEmpty ? "" : "?" + urlParams.map { k, v in "\(k)=\(v)" }.joined(separator: "&")
        let url = URL(string: "\(urlString)\(urlSuffix)")!
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}
