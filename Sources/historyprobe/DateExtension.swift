//
//  DateExtension.swift
//

import Foundation
import CryptoKit

extension Date {
    func md5() -> String {
        let data = self.getCurrentTimeStamp().data(using: .utf8)
        let hash = Insecure.MD5.hash(data: data!)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
    
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func getCurrentTimeStamp () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_hh_mm_ss"
        return (formatter.string(from: Date()) as NSString) as String
    }
}
