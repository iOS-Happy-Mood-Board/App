//
//  traceLog.swift
//  HappyMoodBoard
//
//  Created by ukBook on 1/11/24.
//

import Foundation


/// 앱 로그 - 호출한 파일명, 라인 넘버, 함수명을 추적 가능한 함수
/// - Parameters:
///   - description: 디버그할 로그
///   - fileName: 파일명
///   - lineNumber: 라인 넘버
///   - functionName: 함수명
internal func traceLog(_ description: Any,
           fileName: String = #file,
           lineNumber: Int = #line,
           functionName: String = #function) {

    let traceString = "\(fileName.components(separatedBy: "/").last!) -> \(functionName) -> \(description) (line:\(lineNumber))"
    print(traceString)
}
