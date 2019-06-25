//
//  Util.swift
//

import Foundation
import SQLite3

func getAllUsers() -> [String] {
    let defaultAuthority = CSGetLocalIdentityAuthority().takeUnretainedValue()
    let query = CSIdentityQueryCreate(nil, kCSIdentityClassUser, defaultAuthority).takeRetainedValue()
    var error : Unmanaged<CFError>? = nil
    CSIdentityQueryExecute(query, 0, &error)
    let results = CSIdentityQueryCopyResults(query).takeRetainedValue()
    let resultsCount = CFArrayGetCount(results)
    var allUsers = [String]()
    for i in 0..<resultsCount {
        let identity = unsafeBitCast(CFArrayGetValueAtIndex(results, i), to: CSIdentity.self)
        if let cfUserName = CSIdentityGetPosixName(identity)?.takeRetainedValue() {
            let userName = cfUserName as String
            allUsers.append(userName)
        }
    }
    return allUsers
}

func getBrowserHistory(dbPath: String, dbName: String, query: String, browser: BrowserType) -> [HistoryEntry] {
    var history = [HistoryEntry]()
    var db: OpaquePointer?
    
    let copiedDbName = copyDatabase(filePath: dbPath, fileName: dbName)
    guard sqlite3_open(copiedDbName, &db) == SQLITE_OK else {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("error opening history database: \(copiedDbName)\n\(errmsg)")
        sqlite3_close(db)
        return history
    }
    print("opened database: \(copiedDbName)")
    
    var stmt: OpaquePointer?
    if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("error preparing select: \(errmsg)")
        return history
    }

    while sqlite3_step(stmt) == SQLITE_ROW {
        let visit_time = Double(sqlite3_column_int64(stmt, 0))
        var timeStamp = Date()
        if browser == .chrome || browser == .edge || browser == .opera {
            // Chromium browsers are weird and store time as the seconds since 01/01/1601
            timeStamp = Date(timeIntervalSince1970: (visit_time / 1000000) - 11644473600)
        } else if browser == .firefox {
            timeStamp = Date(timeIntervalSince1970: visit_time / 1000000)
        } else if browser == .safari {
            timeStamp = Date(timeIntervalSinceReferenceDate: visit_time)
        }
        var url = "null"
        if let urlPtr = sqlite3_column_text(stmt, 1) {
            url = String(cString: urlPtr)
        }
        var title = "null"
        if let titlePtr = sqlite3_column_text(stmt, 2) {
            title = String(cString: titlePtr).replacingOccurrences(of: ",", with: "")
        }

        history.append(HistoryEntry(url: String(describing: url), title: String(describing: title), timeStamp: timeStamp))
    }
    sqlite3_finalize(stmt)
    sqlite3_close(db)
    print("closed database: \(copiedDbName)")
    deleteDatabaseCopy(fileName: copiedDbName)
    return history
}

fileprivate func copyDatabase(filePath: String, fileName: String) -> String {
    let databaseFile = "\(filePath)\(fileName)"
    do {
        sleep(1) // Laziness
        let copyName = Date().md5()
        try FileManager.default.copyItem(at: URL(fileURLWithPath: databaseFile), to: URL(fileURLWithPath: copyName))
        print("copied database: \(databaseFile) to: \(copyName)")
        return copyName
    } catch (let error) {
        print(error)
        return ""
    }
}

fileprivate func deleteDatabaseCopy(fileName: String) {
    do {
        let files = getContentsOfDirectoryAtPath(path: FileManager.default.currentDirectoryPath)
        try files?.forEach {
            if $0.contains(fileName) {
                try FileManager.default.removeItem(atPath: $0)
                print("deleted copy of database: \($0)")
            }
        }
    } catch (let error) {
        print(error)
    }
}

func getContentsOfDirectoryAtPath(path: String) -> [String]? {
    guard let paths = try? FileManager.default.contentsOfDirectory(atPath: path) else { return nil }
    return paths.map { content in (path as NSString).appendingPathComponent(content)}
}

func killBrowserProcess(browserProcess: String) {
    let pipe = Pipe()
    let proc = Process()
    proc.launchPath = "/usr/bin/killall"
    proc.arguments = [browserProcess]
    proc.standardOutput = pipe
    proc.standardError = pipe
    proc.launch()
    proc.waitUntilExit()
}

func writeLineToFile(outputFile: String, line: String) {
    do {
        let fileHandle = try FileHandle(forWritingTo: URL(fileURLWithPath: outputFile))
        fileHandle.seekToEndOfFile()
        fileHandle.write(line.data(using: .utf8)!)
        fileHandle.closeFile()
    } catch {
        print("error writing to csv file \(error)")
    }
}

