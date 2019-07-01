//
//  Browser.swift
//

import Foundation

class Browser: Hashable {
    var type: BrowserType
    var longName: String
    var appName: String
    var processName: String
    var profileRoot: String
    var storeName: String
    var multipleProfiles: Bool
    var query: String
    var fingerprint: BrowserFingerprint
    
    init(type: BrowserType, appName: String, longName: String, processName: String, profileRoot: String, storeName: String, multipleProfiles: Bool, query: String, fingerprint: BrowserFingerprint) {
        self.type = type
        self.appName = appName
        self.longName = longName
        self.processName = processName
        self.profileRoot = profileRoot
        self.storeName = storeName
        self.multipleProfiles = multipleProfiles
        self.query = query
        self.fingerprint = fingerprint
    }
    
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
    
    static func createSupportedBrowsers() -> [Browser] {
        let braveFingerprint = BrowserFingerprint(type: .filecontents, subject: "Secure Preferences", matchValue: "Brave Browser.app")
        let chromeFingerprint = BrowserFingerprint(type: .filecontents, subject: "Secure Preferences", matchValue: "Chrome.app")
        let edgeFingerprint = BrowserFingerprint(type: .filecontents, subject: "Secure Preferences", matchValue: "Microsoft Edge.app")
        let firefoxFingerprint = BrowserFingerprint(type: .filename, subject: "places.sqlite", matchValue: "places.sqlite")
        let operaFingerprint = BrowserFingerprint(type: .filecontents, subject: "Secure Preferences", matchValue: "Opera.app")
        let safariFingerprint = BrowserFingerprint(type: .filename, subject: "History.db", matchValue: "History.db")
        let vivaldiFingerprint = BrowserFingerprint(type: .filecontents, subject: "Secure Preferences", matchValue: "Vivaldi.app")
        
        let brave = Browser(type: .brave, appName: "Brave Browser.app", longName: "Brave", processName: "Brave Browser", profileRoot: "/Library/Application Support/BraveSoftware/Brave-Browser/", storeName: "History", multipleProfiles: true, query: "SELECT v.visit_time, u.url, u.title FROM visits AS v JOIN urls AS u ON v.url = u.id ORDER BY v.visit_time ASC", fingerprint: braveFingerprint)
        let chrome = Browser(type: .chrome, appName: "Chrome.app", longName: "Google Chrome", processName: "chrome", profileRoot: "/Library/Application Support/Google/Chrome/", storeName: "History", multipleProfiles: true, query: "SELECT v.visit_time, u.url, u.title FROM visits AS v JOIN urls AS u ON v.url = u.id ORDER BY v.visit_time ASC", fingerprint: chromeFingerprint)
        let edge = Browser(type: .edge, appName: "Microsoft Edge.app", longName: "Microsoft Edge", processName: "edge", profileRoot: "/Library/Application Support/Microsoft Edge Dev/", storeName: "History", multipleProfiles: true, query: "SELECT v.visit_time, u.url, u.title FROM visits AS v JOIN urls AS u ON v.url = u.id ORDER BY v.visit_time ASC", fingerprint: edgeFingerprint)
        let firefox = Browser(type: .firefox, appName: "Firefox.app", longName: "Mozilla Firefox", processName: "firefox", profileRoot: "/Library/Application Support/Firefox/Profiles/", storeName: "places.sqlite", multipleProfiles: true, query: "SELECT hv.visit_date, p.url, p.title FROM moz_places AS p JOIN moz_historyvisits AS hv ON p.id = hv.place_id ORDER BY hv.visit_date ASC", fingerprint: firefoxFingerprint)
        let opera = Browser(type: .opera, appName: "Opera.app", longName: "Opera", processName: "opera", profileRoot: "/Library/Application Support/com.operasoftware.Opera/", storeName: "History", multipleProfiles: true, query: "SELECT v.visit_time, u.url, u.title FROM visits AS v JOIN urls AS u ON v.url = u.id ORDER BY v.visit_time ASC", fingerprint: operaFingerprint)
        let safari = Browser(type: .safari, appName: "Safari.app", longName: "Apple Safari", processName: "safari", profileRoot: "/Library/Safari/", storeName: "History.db", multipleProfiles: false, query: "SELECT hv.visit_time, hi.url, hv.title FROM history_items AS hi JOIN history_visits AS hv ON hi.id = hv.history_item ORDER BY hv.visit_time ASC", fingerprint: safariFingerprint)
        let vivaldi = Browser(type: .vivaldi, appName: "Vivaldi.app", longName: "Vivaldi", processName: "Vivaldi", profileRoot: "/Library/Application Support/Vivaldi/", storeName: "History", multipleProfiles: true, query: "SELECT v.visit_time, u.url, u.title FROM visits AS v JOIN urls AS u ON v.url = u.id ORDER BY v.visit_time ASC", fingerprint: vivaldiFingerprint)
        
        var browsers = [Browser]()
        browsers.append(brave)
        browsers.append(chrome)
        browsers.append(edge)
        browsers.append(firefox)
        browsers.append(opera)
        browsers.append(safari)
        browsers.append(vivaldi)
        return browsers
    }
}
