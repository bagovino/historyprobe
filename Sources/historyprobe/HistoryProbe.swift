//
//  File.swift
//  


import Foundation

@main
struct HistoryProbe {
    static func main() async {
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
        var allHistoryMap = await searchForBrowsers(browsers: browsers)
        
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
        exit(0)
    }
    
    private static func searchForBrowsers(browsers: [Browser]) async -> [Browser: [String]] {
        var allHistoryMap: [Browser: [String]] = [:]
        let rootPath = "/Users/"
        
        do {
            try await withThrowingTaskGroup(of: (browser: Browser, history: [String]).self) { taskGroup in
                print("beginning search for browser profiles")
                for browser in browsers {
                    taskGroup.addTask {
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
                        return (browser, matchedPaths)
                    }
                }
                
                for try await result in taskGroup {
                    allHistoryMap[result.browser] = result.history
                    print("completed search for \(result.browser.longName)")
                }
            }
        } catch {
            print("error searching for browser profiles: \(error.localizedDescription)")
        }
    
        print("all browser profile searches completed")
        return allHistoryMap
    }
}
