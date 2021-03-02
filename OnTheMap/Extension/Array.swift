//
//  Array.swift
//  OnTheMap
//
//  from a hackingwithSwift article by Paul Hudson dated 28/05/19 accessed 01/03/21
// found at: https://www.hackingwithswift.com/example-code/language/how-to-remove-duplicate-items-from-an-array


import Foundation


extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
