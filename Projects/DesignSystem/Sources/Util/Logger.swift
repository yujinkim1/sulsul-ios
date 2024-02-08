//
//  Logger.swift
//  DesignSystem
//
//  Created by 이범준 on 2023/11/21.
//

import Foundation
import CocoaLumberjack
import CocoaLumberjackSwift

#if RELEASE
@inline(__always)
public func LogDebug(_ item: Any, functionName: StaticString = #function, fileName: StaticString = #file, line: UInt = #line) {
}
@inline(__always)
public func LogError(_ item: Any, functionName: StaticString = #function, fileName: StaticString = #file, line: UInt = #line) {
}
#else
@inline(__always)
public func LogDebug(_ item: Any,
                     functionName: StaticString = #function,
                     fileName: StaticString = #file,
                     line: UInt = #line) {
    DDLogVerbose(String(describing: item), file: fileName, function: functionName, line: line)
    print("==================start===================")
    dump(fileName)
    dump(functionName)
    dump(line)
    dump(item)
    print("==================end===================")
}
@inline(__always)
public func LogError(_ item: Any,
                     functionName: StaticString = #function,
                     fileName: StaticString = #file,
                     line: UInt = #line) {
    DDLogError(String(describing: item), file: fileName, function: functionName, line: line)
    print("==================start===================")
    dump(fileName)
    dump(functionName)
    dump(line)
    dump(item)
    print("==================end===================")
}

#endif
