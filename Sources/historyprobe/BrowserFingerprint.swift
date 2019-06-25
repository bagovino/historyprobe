//
//  BrowserFingerprint.swift
//

struct BrowserFingerprint {
    enum FingerprintType {
        case filename
        case filecontents
    }
    
    var type: FingerprintType
    var subject: String
    var matchValue: String
    
    init(type: FingerprintType, subject: String, matchValue: String) {
        self.type = type
        self.subject = subject
        self.matchValue = matchValue
    }
}
