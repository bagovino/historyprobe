//
//  Browser.swift
//

import Foundation

struct Browser: Hashable, Codable {
    enum BrowserType: String, Codable {
        case chromium
        case firefox
        case safari
    }
    
    let type: Browser.BrowserType
    let longName: String
    let appName: String
    let processName: String
    let profileRoot: String
    let storeName: String
    let multipleProfiles: Bool
    let query: String
    let fingerprint: BrowserFingerprint
    
    public func fingerprintMatches(filePath: String, fileName: String) -> Bool {
        switch self.fingerprint.type {
            case .filename: return self.fingerprint.matchValue == fileName
            case .filecontents:
                do {
                    let fileContents = try String(contentsOfFile: filePath + "/" + fileName)
                    return fileContents.contains(self.fingerprint.matchValue)
                } catch {
                    return false
                }
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.type)
    }
    
    static func == (lhs: Browser, rhs: Browser) -> Bool {
        return lhs.type == rhs.type
    }
}
