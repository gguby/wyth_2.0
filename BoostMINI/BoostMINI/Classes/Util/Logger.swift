//
//  Logger.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 21..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//

// 사용법 예시
// 초기화. 딱히 필요없지만 아래처럼 로그 대상 설정 가능
// Logger.destination = [.console, .file]
//
// 그냥 아래처럼 사용.
// logDebug("123")

import Foundation
import SwiftyBeaver
import Crashlytics

// INFO: beaverCloud 사용할거면 .beaverCloud쪽과 요녀석의 주석을 해제할 것. defines로 옮겨도 되고.
//fileprivate struct SBPlatformConst {
//    static let appID = "Enter App ID Here - o8QXpN"
//    static let appSecret = "Enter App Secret Here - zofadrcs8pbmknanqjaAkzepf1sljkfc"
//    static let encryptionKey = "Enter Encryption Key Here - vLhboSulLqpulpq5gvufnmpfyvgKgwse"
//}

public typealias LogLevel = SwiftyBeaver.Level
public typealias LogDestination = Logger.LogDestination

// 아래 함수들을 사용하여 로그를 출력.

public func log(_ items: Any...,
	level: LogLevel = .info,
	file: String = #file,
	function: String = #function,
	line: Int = #line) {
	Logger.push(level: level, message: Logger.join(items), context: nil, file: file, function: function, line: line)
}

public func logVerbose(_ items: Any...,
	context: Any? = nil,
	file: String = #file,
	function: String = #function,
	line: Int = #line) {
	Logger.push(level: .verbose, message: Logger.join(items), context: context, file: file, function: function, line: line)
}

public func logDebug(_ items: Any...,
	context: Any? = nil,
	file: String = #file,
	function: String = #function,
	line: Int = #line) {
	Logger.push(level: .debug, message: Logger.join(items), context: context, file: file, function: function, line: line)
}

public func logInfo(_ items: Any...,
	context: Any? = nil,
	file: String = #file,
	function: String = #function,
	line: Int = #line) {
	Logger.push(level: .info, message: Logger.join(items), context: context, file: file, function: function, line: line)
}

public func logWarning(_ items: Any...,
	context: Any? = nil,
	file: String = #file,
	function: String = #function,
	line: Int = #line) {
	Logger.push(level: .warning, message: Logger.join(items), context: context, file: file, function: function, line: line)
}

public func logError(_ items: Any...,
	context: Any? = nil,
	file: String = #file,
	function: String = #function,
	line: Int = #line) {
	Logger.push(level: .error, message: Logger.join(items), context: context, file: file, function: function, line: line)
}


// Logger 구현 부분입니다. 로거 사용과 관련된 부분들이 있습니다.
public class Logger {

    /// 로그를 남길 대상 설정.
    /// ( OptionSet임. [ .a, .b ] 또는 destination.insert(##) 를 통해 여러곳을 동시에 지정 가능.
	/// 기본값은 콘솔.
    static var destination: LogDestination = .console {
        didSet { self.touch(true) }
    }

    /// 로깅 최소 레벨. (이 값 미만의 로그는 보이지 않음)
    ///
    /// - Parameter type: 로깅 대상을 지정. (생략 또는 nil 일 경우, 모든 대상에 대해 체크)
    /// - Returns: 해당 대상의 로깅 최소래벨을 반환.
    /// 		단, 대상이 지정되지 않았으나, 대상별로 로깅레벨이 다르다면 nil 반환.
    public static func minLogLevel(_ destination: LogDestination? = nil) -> LogLevel? {
        return Logger._minLogLevel(destination) // conceal
    }

    /// 로깅 최소 레벨 지정
    ///
    /// - Parameters:
    ///   - level: 로깅 최소 레벨 입력
    ///   - destination: 로깅 최소 레벨을 적용할 대상 지정. (생략시 모든 대상에 대해 일괄 변경)
    ///
    /// - 참고 : destination을 생략하고 지정할 경우, 로깅 최소 레벨 기본값도 함께 변함.
    public static func setMinLogLevel(_ level: LogLevel, destination: LogDestination? = nil) {
        Logger._setMinLogLevel(level, destination: destination) // conceal
    }
	
	
	/// 로그 데이터들을 스트링으로 빌드.
	///
	/// - Parameters:
	///   - destination: 로그를 출력할 대상. 생략시(=nil) 설정된 모든 대상에 대해 출력.
	///                  대상 지정시 해당 대상에만 출력 (로깅 대상 목록(destination)에 없어도 해당 대상으로 출력됨)
	///   - message: 보통 스트링. format(args...) 형태 가능.
	///   - message: 보통 스트링. format(args...) 형태 가능.
	///   - context: 기타 구조체 등등.
	///   - file: 파일명 (#file 로 받아와서 넣어줌)
	///   - function:  함수명 (#function 으로 받아와서 넣어줌)
	///   - line: 줄 번호 (#line 으로 받아와서 넣어줌)
	internal class func push(
		level: LogLevel = .info,
		message: @autoclosure () -> Any,
		context: Any? = nil,
		file: String = #file,
		function: String = #function,
		line: Int = #line) {
		
		beaver.custom(level: level, message: message, file: file, function: function, line: line, context: context)
	}

	fileprivate static func join(_ something:Any) -> String {
		if let arr = something as? [String] {
			return arr.joined()
		}
		if let arr = something as? [Any] {
		}
		return "\(something)"
	}
	
	
	/// 로그를 쏴줄 실 구현체. (초기화를 위해 터치를 넣음)
	/// addFilter 등을 쓰고싶으면 여기에 직접!.
	static var beaver: SwiftyBeaver.Type {
		Logger.touch(false)
		return SwiftyBeaver.self
	}
}





// MARK: - file private
// Logger 내부 실구현 부분입니다. Logger를 사용하는 다른 파일들에서는 보실 필요 없음.
extension Logger {

	
	
	/// 로그 대상 목록.
	public struct LogDestination: OptionSet, Hashable {
		public let rawValue: Int
		public var hashValue: Int { return rawValue }
		public var defaultHashValue: Int {
			if rawValue == 0 {
				return 0
			}
			let dd = log2(Double(rawValue))
			return dd.isNaN ? 0 : Int(dd)
		}
		
		public static let none = LogDestination(rawValue: 0)
		public static let console = LogDestination(rawValue: 1 << 1)
		public static let file = LogDestination(rawValue: 1 << 2)
		public static let crashlytics = LogDestination(rawValue: 1 << 3)
		//public static let beaverCloud = LogDestination(rawValue: 1 << 4)
		
		public init(rawValue: Int) {
			self.rawValue = rawValue
		}
	}
	
    /// 초기화.
    ///
    /// - Parameter force: true이면 강제 초기화.
    fileprivate static func touch(_ force: Bool = false) {
        // lazy init once. 반드시 한 번 호출해줘야하는 초기화이고, 그 후에는 호출해도 초기화하지 않는 그런 친구여야 함.
        let dests = SwiftyBeaver.self.destinations // beaver 호출하면 무한루프되므로 호출금지.
        if dests.count > 0 {
            // destination이 있으면 초기화된 것으로 간주.
            // destination을 없게 하고싶으면 NilDestination 추가. (.none)
            if not(force) {
                return
            }
        }
		
		// TODO : remove하지않는다. 일단 다 선언하여 대상별로 로그를 쓸 수 있게 수정해야함.

        var arrayNewDefaultHashValues: [Int] = []
        for tmp in destination.elements() {
            arrayNewDefaultHashValues.append(tmp.defaultHashValue)
        }

        var exists: [BaseDestination] = []
        var removes: [BaseDestination] = []
        var adds: [BaseDestination] = []

        for tmp in dests {
            if arrayNewDefaultHashValues.contains(tmp.defaultHashValue) && tmp.defaultHashValue != 0 {
                exists.append(tmp)
            } else {
                removes.append(tmp)
            }
        }

        for tmp in destination.elements() {
            let hv = tmp.defaultHashValue
            if not(exists.contains(where: { obj in obj.defaultHashValue == hv })) {
                adds.append(makeDestination(tmp))
            }
        }

        if (dests.count - removes.count) <= 0 && adds.count == 0 {
            // 개수가 없으면 없는걸로 처리하여 추가.
            if let idx = removes.index(where: { dd -> Bool in dd.defaultHashValue == 0 }) {
                removes.remove(at: idx)
            } else {
                adds.append(makeDestination(.none))
            }
        }

        // 제거
        for x in removes {
            SwiftyBeaver.removeDestination(x)
        }
        // 추가
        for x in adds {
            SwiftyBeaver.addDestination(x)
        }
    }

    /// 로깅 최소 레벨 기본값. (변동 가능)
    fileprivate static var defaultMinLevel: LogLevel = .info

    fileprivate static func _minLogLevel(_ destination: LogDestination? = nil) -> LogLevel? {
        if let dest = destination {
            return Logger.getDestination(dest)?.minLevel
        }

        var result: LogLevel? = nil
        for dd in beaver.destinations {
            result = result ?? dd.minLevel
            if dd.minLevel != result! {
                return nil
            }
        }
        return result
    }

    fileprivate static func _setMinLogLevel(_ level: LogLevel, destination: LogDestination? = nil) {
        if let dest = destination {
            if let target = Logger.getDestination(dest) {
                target.minLevel = level
            }
            return
        }
        for dd in beaver.destinations {
            dd.minLevel = level
        }
        defaultMinLevel = level // 기본값도 업데이트.
    }

    /// 로깅 대상 설정(초기화. 환경변수 입력)
    fileprivate static func makeDestination(_ destination: LogDestination) -> BaseDestination {
        var manager: BaseDestination!
        let baseLevel = defaultMinLevel
        var format = "$DMM.dd HH:mm:ss.SSS$d $C$L$c: $M" // full datetime, colored log level and message

        switch destination {
        case .none:
            manager = NilDestination()

        case .console:
            manager = ConsoleDestination()
            format = "$Dmm:ss$d $L: $M" // hour, minute, second, loglevel and message

        case .file:
            let file = FileDestination()
            file.levelString.error = "[?]"
            if let url = try? FileManager.default.url(for: .documentDirectory,
                                                      in: .userDomainMask,
                                                      appropriateFor: nil,
                                                      create: true) {
                let fileURL = url.appendingPathComponent("app_log.log")
                file.logFileURL = fileURL
                #if DEBUG
                    print("file log path = \(fileURL.absoluteString)")
                #endif
            }
            manager = file

        case .crashlytics:
            manager = CrashlyticsDestination()

//        case .beaverCloud:
//            manager = SBPlatformDestination(appID: SBPlatformConst.appID,
//                                            appSecret: SBPlatformConst.appSecret,
//                                            encryptionKey: SBPlatformConst.encryptionKey)
        default:
            // ERROR
            print("makeDestination Error!")
            //break
        }
        // 공통 초기화
        manager.format = format
        manager.minLevel = baseLevel

        return manager
    }

    typealias SequenceOptionSet = OptionSet & Sequence

	fileprivate static var destinationCache: [LogDestination: BaseDestination] = [:]
		
	static func getDestination(_ destination: LogDestination) -> BaseDestination? {
        var manager: BaseDestination!
        var format: String = "$Dyyyy-MM-dd HH:mm:ss.SSS$d $T $L: $M"
        // log thread, date, time in milliseconds, level & message
		
		if let target = destinationCache[destination] {
			return target
		}
		
        switch destination {
        case .none:
            format = ""

        case .console:
            manager = ConsoleDestination()
            format = "$Dmm:ss$d $L: $M" // hour, minute, second, loglevel and message

        case .file:
            let file = FileDestination()
            file.levelString.error = "[?]"
            if let url = try? FileManager.default.url(for: .documentDirectory,
                                                      in: .userDomainMask,
                                                      appropriateFor: nil,
                                                      create: true) {
                let fileURL = url.appendingPathComponent("app_log.log")
                file.logFileURL = fileURL
            }
//            manager = file

        case .crashlytics:
            manager = CrashlyticsDestination()

//        case .beaverCloud:
//            manager = SBPlatformDestination(appID: SBPlatformConst.appID,
//                                            appSecret: SBPlatformConst.appSecret,
//                                            encryptionKey: SBPlatformConst.encryptionKey)
        default:
            // ERROR
            print("makeDestination Error!")
            //break
        }

        manager.format = format
		destinationCache[destination] = manager

        return manager
    }
	

	// MARK: - SwiftyBeaver's internal 
	
	
	class func stringFind(_ string:String, _ char: Character) -> String.Index? {
		#if swift(>=3.2)
			return string.index(of: char)
		#else
			return string.characters.index(of: char)
		#endif
	}

	class func stripParams(function: String) -> String {
		var f = function
		if let indexOfBrace = stringFind(f, "(") {
			#if swift(>=4.0)
				f = String(f[..<indexOfBrace])
			#else
				f = f.substring(to: indexOfBrace)
			#endif
		}
		f += "()"
		return f
	}

	
	/// SwityBeaver의 코드.
	/// returns the current thread name
	class func threadName() -> String {
		
		#if os(Linux)
			// on 9/30/2016 not yet implemented in server-side Swift:
			// > import Foundation
			// > Thread.isMainThread
			return ""
		#else
			if Thread.isMainThread {
				return ""
			} else {
				let threadName = Thread.current.name
				if let threadName = threadName, !threadName.isEmpty {
					return threadName
				} else {
					return String(format: "%p", Thread.current)
				}
			}
		#endif
	}

}
