//
//  HistoryEntry.swift
//

import Foundation

struct HistoryEntry {
    var url: String
    var title: String
    var timeStamp: Date
    
    init(url: String, title: String, timeStamp: Date) {
        self.url = url
        self.title = title
        self.timeStamp = timeStamp
    }
}
