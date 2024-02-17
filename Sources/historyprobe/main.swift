//
//  main.swift
//

import Foundation

print("initializing")
var browsers: [Browser] = [Browser]()
do {
    let data = BrowserDefinitions.string.data(using: .utf8)
    let decoder = JSONDecoder()
    browsers.append(contentsOf: try decoder.decode([Browser].self, from: data!))
} catch {
    print("error reading browser json")
    exit(1)
}

let host = Host.current().localizedName ?? "Unknown"
let outputFile = "\(host)-\(Date().getCurrentTimeStamp())-results.csv"

var allHistory = [String]()
var allHistoryMap: [Browser: [String]] = [:]
let rootPath = "/Users/"

let searchGroup = DispatchGroup()
let concurrentQueue = DispatchQueue(label: "history-probe.queues.concurrent", attributes: .concurrent)
let mapSemaphore = DispatchSemaphore(value: 1)

print("beginning search for browser profiles")
for browser in browsers {
    concurrentQueue.async(group: searchGroup) {
        print("starting search for \(browser.longName)")
        var matchedPaths = [String]()
        if let tree = FileManager.default.enumerator(atPath: rootPath) {
            while let nodeName = tree.nextObject() as? NSString {
                let fullPath = rootPath + (nodeName as String)
                let containingPath =  rootPath + nodeName.deletingLastPathComponent
                var isDir: ObjCBool = false
                FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDir)
                if !isDir.boolValue && nodeName.lastPathComponent == browser.fingerprint.subject {
                    if browser.fingerprintMatches(filePath: containingPath, fileName: nodeName.lastPathComponent as String) {
                        print("\(browser.longName) profile possibly discovered at: \(containingPath)")
                        matchedPaths.append(containingPath)
                    }
                }
            }
        }
        
        mapSemaphore.wait()
        allHistoryMap[browser] = matchedPaths
        mapSemaphore.signal()
        print("completed search for \(browser.longName)")
    }
}

searchGroup.notify(queue: concurrentQueue) {
    print("all browser profile search completed")
}
searchGroup.wait()

allHistory.append("Timestamp,URL,Title,Account,Browser,Profile\n")
for browser in browsers {
    for browserProfile in allHistoryMap[browser] ?? [String]() {
        let user = browserProfile.getUserFromPath()
        var profilePosition = browserProfile.lastIndex(of: "/")
        profilePosition = browserProfile.index(profilePosition!, offsetBy: 1)
        let profileName = String(browserProfile[profilePosition!...])
        let history = getBrowserHistory(dbPath: browserProfile + "/", dbName: browser.storeName, query: browser.query, browser: browser.type)
        history.forEach { allHistory.append("\($0.timeStamp),\($0.url),\($0.title),\(user),\(browser.longName),\(profileName)\n") }
    }
}

FileManager.default.createFile(atPath: outputFile, contents: nil, attributes: nil)
allHistory.forEach {
    writeLineToFile(outputFile: outputFile, line: $0)
}

print("exported \(allHistory.count) history entries to csv")


