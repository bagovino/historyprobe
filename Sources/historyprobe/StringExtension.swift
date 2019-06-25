//
//  StringExtension.swift
//

extension String {
    func lastIndexOfCharacter(_ c: Character) -> Int? {
        return range(of: String(c), options: .backwards)?.lowerBound.utf16Offset(in: String(c))
    }
    
    func getUserFromPath() -> String {
        guard self.starts(with: "/Users/") else {
            return ""
        }
        return String(self.split(separator: "/")[1])
    }
    
    func substring(to : Int) -> String {
        let toIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[...toIndex])
    }
    
    func substring(from : Int) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: from)
        return String(self[fromIndex...])
    }
}
