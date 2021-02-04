//
//  BrowserFingerprint.swift
//

struct BrowserFingerprint: Codable {
    enum FingerprintType: String, Codable {
        case filename
        case filecontents
    }
    
    let type: FingerprintType
    let subject: String
    let matchValue: String
}
