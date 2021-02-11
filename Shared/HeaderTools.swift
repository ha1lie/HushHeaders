//
//  HeaderTools.swift
//  HushHeaders
//
//  Created by Hallie on 2/7/21.
//

import Foundation

enum FrameworkType {
    case priv
    case pub
}
struct HeaderTools {
    
    private let publicFrameworks: [String]
    private let privateFrameworks: [String]
    
    init() {
        if let path = Bundle.main.path(forResource: "FrameworkNames", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? Dictionary<String, AnyObject>
                let frames: Dictionary<String, Array<String>> = jsonResult?["frameworks"] as! Dictionary<String, Array<String>>
                self.publicFrameworks = frames["public"]! as Array<String>
                self.privateFrameworks = frames["private"]! as Array<String>
            } catch {
                print("Yeah, couldn't get the json file about the other files")
                self.publicFrameworks = []
                self.privateFrameworks = []
            }
        } else {
            self.publicFrameworks = []
            self.privateFrameworks = []
        }
    } // Initializes the starting frameworks by registering them from our JSON file
    
    func retrieveFrameworks(_ type: FrameworkType, iOSVersion: String = "14.0") -> [String] {
        return type == .pub ? self.publicFrameworks : self.privateFrameworks
    } // Return our saved frameworks. Defaults to the only saved set ~ iOS 14
    
    func retrieveHeaders(for framework: String, in iOSVersion: String = "14.0", isPrivate: Bool) -> [String] {
        print("Retrieving headers from: \(framework)")
        var path = Bundle.main.bundlePath
        #if os(macOS)
        path += "/Contents/Resources"
        #endif
        path += "/runheads/\(isPrivate ? "PrivateFrameworks" : "Frameworks")/\(framework)"
        print("Path to retrieve them: \(path)")
        var docsArray: [String] = []
        do {
            docsArray = try FileManager.default.contentsOfDirectory(atPath: path)
        } catch {
            print("Could not get contents of \(framework)'s Framework directory")
        }
        return docsArray.map{ $0.replacingOccurrences(of: ".txt", with: "") }
    } // Return the header file names for specific framework and iOS version ~ Version doesn't change
    
    func retrieveHeaderContents(_ header: String, for framework: String, in iOSVersion: String = "14.0", isPrivate: Bool) -> [String] {
        var returnable = ""
        var path = Bundle.main.bundlePath
        #if os(macOS)
        path += "/Contents/Resources"
        #endif
        path += "/runheads/\(isPrivate ? "PrivateFrameworks" : "Frameworks")/\(framework)/\(header).txt"
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            returnable = String(data: data, encoding: .utf8) ?? "Couldn't convert header contents to String"
        } catch {
            print("Couldn't find the header file!")
        }
        return returnable.components(separatedBy: "\n")
    } // Return the contents of the header in an array by line
    
}
