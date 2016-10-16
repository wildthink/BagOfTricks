//
//  CoreJS.swift
//  BagOfTricks
//
//  Created by Jason Jobe on 10/15/16.
//  Copyright © 2016 WildThink. All rights reserved.
//

import Foundation
import JavaScriptCore

public enum LogLevel { case debug }

public func log(_ level: LogLevel, _ message: String) {
    //    Logger.defaultInstance.log(level, message: message)
}

public enum CoreJSError: Error {
    case fileDoesNotExist
    case fileCouldNotBeLoaded
    case failedToDownloadScript
    case failedToEvaluateScript
}

class JSBridge: NSObject {
//    open var outputHandler: OutputHandler? = nil
}

@objc(CoreJS)
open class CoreJS: NSObject {


    open var context: JSContext {
        didSet {
            for (name, script) in bridges {
                context.setObject(script, forKeyedSubscript: name as (NSCopying & NSObjectProtocol)!)
            }

            context.exceptionHandler = { context, exception in
                log(.debug, "JSError = \(exception)")
            }
        }
    }

    fileprivate(set) open var bridges = [String: JSExport]()

    public override init() {
        context = JSContext(virtualMachine: JSVirtualMachine())
        context.setObject(JSBridge(), forKeyedSubscript: "bridge" as (NSCopying & NSObjectProtocol))
    }

    public func reset() {
        context = JSContext(virtualMachine: JSVirtualMachine())
    }

    open subscript(key: String) -> JSValue? {
        get {
            guard let result = context.objectForKeyedSubscript(key) else { return nil }
            if result.isNull || result.isUndefined { return nil }
            return result
        }
        set {
            context.setObject(newValue, forKeyedSubscript: key as (NSCopying & NSObjectProtocol)!)
        }
    }

    /**
     Load JS from a file at the given path.

     - parameter filePath: Path to the JS file.
     */
    open func loadFromFile(_ filePath: String) throws {
        guard FileManager.default.fileExists(atPath: filePath) else {
            throw CoreJSError.fileDoesNotExist
        }
        guard let script = try? String(contentsOfFile: filePath, encoding: String.Encoding.utf8) else {
            throw CoreJSError.fileCouldNotBeLoaded
        }

        try load(script)
    }

    /**
     Load JS from a resource at the given URL.

     - parameter downloadURL: URL to the JS resource.
     - parameter completion: The completion block to call after the resource is loaded into the bridge.
     */
    open func loadFromURL(_ downloadURL: URL, completion: @escaping (_ error: Error?) -> Void) {
        downloadScript(downloadURL) { (data, error) -> Void in
            if let error = error {
                completion(error)
            } else {
                if let data = data, let script = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String? {
                    do {
                        try self.load(script)
                        completion(nil)
                    } catch let catchError as NSError {
                        completion(catchError)
                    } catch {
                        completion(CoreJSError.failedToDownloadScript)
                    }
                } else {
                    completion(CoreJSError.failedToDownloadScript)
                }
            }
        }
    }

    open func call (_ key: String, with argv: [Any?]) -> Any? {

        guard let lambda = context.objectForKeyedSubscript(key) else { return nil }
        if lambda.isNull || lambda.isUndefined { return nil }

        let result = lambda.call(withArguments: argv)
        Swift.print (result!)
        return result
    }

    open func evaluate(_ script: String) -> Any {
        if let result = context.evaluateScript(script) {
            if result.isUndefined { return "<undefined>" }
            if result.isNull      { return "<null>" }
            if result.isString    { return result.toString() }
            return result.toObject()
        }
        else {
            return "nil"
        }
    }

    /**
     Load JS from a String.

     - parameter script: The JS to load.
     */
    open func load(_ script: String) throws {
        context.evaluateScript(script)
        if let exception = context.exception {
            log(.debug, "Load failed with exception: \(exception)")
            throw CoreJSError.failedToEvaluateScript
        }
    }

    fileprivate func downloadScript(_ url: URL, completion: @escaping (_ data: Data?, _ error: Error?) -> Void)
    {
        let downloadTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            let httpResponse = response as? HTTPURLResponse
            if httpResponse?.statusCode == 404 {
                completion(nil, CoreJSError.fileDoesNotExist)
            } else {
                completion(data, error)
            }
        })

        downloadTask.resume()
    }
}

// MARL: - Console API

@objc
public protocol JSConsole: JSExport {

    func log (arguments: [AnyObject])
    func warn (arguments: [AnyObject])
    func error (arguments: [AnyObject])
}

/*
 public extension Bridge.Liaison: JSConsole
 {
 func log (arguments: [AnyObject])   { output(.log, arguments: arguments) }
 func warn (arguments: [AnyObject])  { output(.warning, arguments: arguments) }
 func error (arguments: [AnyObject]) { output(.error, arguments: arguments) }

 open func output(_ type: ConsoleOutputType, arguments: [AnyObject]) {
 var output: String = ""

 switch type {
 case .error: output += "⛔️"
 case .warning: output += "⚠️"

 default:
 break
 }

 for i in 0..<arguments.count {
 if let stringValue = arguments[i] as? String {
 output += stringValue
 } else if let jsValue = arguments[i] as? JSValue {
 output += jsValue.toString()
 } else if let dictValue = arguments[i] as? NSDictionary {
 output += String(format: "%@", dictValue)
 }

 if i != arguments.count - 1 {
 output += " "
 }
 }

 if let handler = outputHandler {
 handler(type, output)
 } else {
 print(output)
 }
 }
 }
 */

// MARK: - Exports API

public extension CoreJS {
    /**
     Add an exported object to the context
     - parameter export: Object being exported to JavaScript
     - parameter name: Name of object being exported
     */
    public func addExport<E: JSExport>(_ export: E, name: String) {
        bridges[name] = export
        context.setObject(export, forKeyedSubscript: name as (NSCopying & NSObjectProtocol)!)
    }

    public func addExport<E: JSExport>(_ export: E.Type, name: String) {
        //        exports[name] = export
        context.setObject(export, forKeyedSubscript: name as (NSCopying & NSObjectProtocol)!)
    }

    /**
     Retrieve a JSValue out of the context by name.
     - parameter name: Name of value to retrieve out of context.
     */
    public func contextValueForName(_ name: String) -> JSValue {
        return context.objectForKeyedSubscript(name)
    }
}

