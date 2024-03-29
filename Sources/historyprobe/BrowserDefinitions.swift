//
//  BrowserDefinitions.swift
//

import Foundation

struct BrowserDefinitions {
    static let string = """
[{
        "longName": "Brave",
        "type": "chromium",
        "appName": "Brave Browser.app",
        "processName": "Brave Browser",
        "profileRoot": "/Library/Application Support/BraveSoftware/Brave-Browser/",
        "storeName": "History",
        "multipleProfiles": true,
        "query": "SELECT v.visit_time, u.url, u.title FROM visits AS v JOIN urls AS u ON v.url = u.id ORDER BY v.visit_time ASC",
        "fingerprint": {
            "type": "filecontents",
            "subject": "Secure Preferences",
            "matchValue": "Brave Browser.app"
        }
    },
    {
        "longName": "Chrome",
        "type": "chromium",
        "appName": "Chrome.app",
        "processName": "chrome",
        "profileRoot": "/Library/Application Support/Google/Chrome/",
        "storeName": "History",
        "multipleProfiles": true,
        "query": "SELECT v.visit_time, u.url, u.title FROM visits AS v JOIN urls AS u ON v.url = u.id ORDER BY v.visit_time ASC",
        "fingerprint": {
            "type": "filecontents",
            "subject": "Secure Preferences",
            "matchValue": "Chrome.app"
        }
    },
    {
        "longName": "Microsoft Edge",
        "type": "chromium",
        "appName": "Microsoft Edge.app",
        "processName": "edge",
        "profileRoot": "/Library/Application Support/Microsoft Edge/",
        "storeName": "History",
        "multipleProfiles": true,
        "query": "SELECT v.visit_time, u.url, u.title FROM visits AS v JOIN urls AS u ON v.url = u.id ORDER BY v.visit_time ASC",
        "fingerprint": {
            "type": "filecontents",
            "subject": "Secure Preferences",
            "matchValue": "Microsoft Edge.app"
        }
    },
    {
        "longName": "Mozilla Firefox",
        "type": "firefox",
        "appName": "Firefox.app",
        "processName": "firefox",
        "profileRoot": "/Library/Application Support/Firefox/Profiles/",
        "storeName": "places.sqlite",
        "multipleProfiles": true,
        "query": "SELECT hv.visit_date, p.url, p.title FROM moz_places AS p JOIN moz_historyvisits AS hv ON p.id = hv.place_id ORDER BY hv.visit_date ASC",
        "fingerprint": {
            "type": "filename",
            "subject": "places.sqlite",
            "matchValue": "places.sqlite"
        }
    },
    {
        "longName": "Opera",
        "type": "chromium",
        "appName": "Opera.app",
        "processName": "opera",
        "profileRoot": "/Library/Application Support/com.operasoftware.Opera/",
        "storeName": "History",
        "multipleProfiles": true,
        "query": "SELECT v.visit_time, u.url, u.title FROM visits AS v JOIN urls AS u ON v.url = u.id ORDER BY v.visit_time ASC",
        "fingerprint": {
            "type": "filecontents",
            "subject": "Secure Preferences",
            "matchValue": "Opera.app"
        }
    },
    {
        "longName": "Apple Safari",
        "type": "safari",
        "appName": "Safari.app",
        "processName": "safari",
        "profileRoot": "/Library/Safari/",
        "storeName": "History.db",
        "multipleProfiles": false,
        "query": "SELECT hv.visit_time, hi.url, hv.title FROM history_items AS hi JOIN history_visits AS hv ON hi.id = hv.history_item ORDER BY hv.visit_time ASC",
        "fingerprint": {
            "type": "filename",
            "subject": "History.db",
            "matchValue": "History.db"
        }
    },
    {
        "longName": "Vivaldi",
        "type": "chromium",
        "appName": "Vivaldi.app",
        "processName": "vivaldi",
        "profileRoot": "/Library/Application Support/Vivaldi/",
        "storeName": "History",
        "multipleProfiles": true,
        "query": "SELECT v.visit_time, u.url, u.title FROM visits AS v JOIN urls AS u ON v.url = u.id ORDER BY v.visit_time ASC",
        "fingerprint": {
            "type": "filecontents",
            "subject": "Secure Preferences",
            "matchValue": "Vivaldi.app"
        }
    }
]
"""
}
