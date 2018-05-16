import Foundation

public enum BitcoinEndpoint {
    case realtime(currency: String)
    case historical(currency: String, startDate: Date, endDate: Date)
}
