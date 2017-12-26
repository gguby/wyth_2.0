//
//  LogManager.swift
//  BoostMINI
//
//  Created by jack on 2017. 12. 21..
//  Copyright © 2017년 IRIVER LIMITED. All rights reserved.
//


// 사용법 예시
// 초기화. 딱히 필요없지만 아래처럼 로그 대상 설정 가능
// LogManager.destination = [.console, .file]
//
// 그냥 아래처럼 사용.
// logDebug("123")

import Foundation
import SwiftyBeaver
//import Crashlytics

fileprivate struct SBPlatformConst {
	static let appID         = "Enter App ID Here - o8QXpN"
	static let appSecret     = "Enter App Secret Here - zofadrcs8pbmknanqjaAkzepf1sljkfc"
	static let encryptionKey = "Enter Encryption Key Here - vLhboSulLqpulpq5gvufnmpfyvgKgwse"
}


// 아래 함수들을 사용하여 로그를 출력.

public func track(_ message: String, file: String = #file, function: String = #function, line: Int = #line ) {
	print("\(message) called from \(function) \(file):\(line)")
}

public func logVerbose(_ items: Any..., context:Any? = nil, separator: String = " ", terminator: String = "\n", file: String = #file, function: String = #function, line: Int = #line) {
	LogManager.verbose(items, context: context, separator: " ", terminator: "\n", file: file, function: function, line: line)
}

public func logDebug(_ items: Any..., context:Any? = nil, separator: String = " ", terminator: String = "\n", file: String = #file, function: String = #function, line: Int = #line) {
	LogManager.debug(items, context: context, separator: " ", terminator: "\n", file: file, function: function, line: line)
}

public func logInfo(_ items: Any..., context:Any? = nil, separator: String = " ", terminator: String = "\n", file: String = #file, function: String = #function, line: Int = #line) {
	LogManager.log(items, context: context, separator: " ", terminator: "\n", file: file, function: function, line: line)
}

public func logWarning(_ items: Any..., context:Any? = nil, separator: String = " ", terminator: String = "\n", file: String = #file, function: String = #function, line: Int = #line) {
	LogManager.warning(items, context: context, separator: " ", terminator: "\n", file: file, function: function, line: line)
}

public func logError(_ items: Any..., context:Any? = nil, separator: String = " ", terminator: String = "\n", file: String = #file, function: String = #function, line: Int = #line) {
	LogManager.error(items, context: context, separator: separator, terminator: terminator)
	
	LogManager.error(items, context: context, separator: " ", terminator: "\n", file: file, function: function, line: line)
}


public typealias LogLevel = SwiftyBeaver.Level
public typealias LogDestination = LogManager.LogDestination



public class LogManager {
	
	/// 로그를 남길 대상 설정.
	/// ( OptionSet임. [ .a, .b ] 또는 destination.insert(##) 를 통해 여러곳을 동시에 지정 가능.
	static var destination: LogDestination = .none {
		didSet { self.touch(true) }
	}
	
	
	/// 로깅 최소 레벨. (이 값 미만의 로그는 보이지 않음)
	///
	/// - Parameter type: 로깅 대상을 지정. (생략 또는 nil 일 경우, 모든 대상에 대해 체크)
	/// - Returns: 해당 대상의 로깅 최소래벨을 반환.
	///		단, 대상이 지정되지 않았으나, 대상별로 로깅레벨이 다르다면 nil 반환.
	public static func minLogLevel(_ destination:LogDestination? = nil) -> LogLevel? {
		return LogManager._minLogLevel(destination)		// conceal
	}
	
	/// 로깅 최소 레벨 지정
	///
	/// - Parameters:
	///   - level: 로깅 최소 레벨 입력
	///   - destination: 로깅 최소 레벨을 적용할 대상 지정. (생략시 모든 대상에 대해 일괄 변경)
	///
	/// - 참고 : destination을 생략하고 지정할 경우, 로깅 최소 레벨 기본값도 함께 변함.
	public static func setMinLogLevel(_ level:LogLevel, destination:LogDestination? = nil) {
		LogManager._setMinLogLevel(level, destination: destination)		// conceal
	}
	
	
	
	
	static var beaver: SwiftyBeaver.Type {
		LogManager.touch()
		return SwiftyBeaver.self
	}
	fileprivate static var isSimulator: Bool { return TARGET_OS_SIMULATOR != 0 }
	
	
	public struct LogDestination : OptionSet, Hashable {
		public let rawValue: Int
		public var hashValue: Int { return rawValue }
		public var defaultHashValue: Int {
			if rawValue == 0 {
				return 0
			}
			let dd = log2(Double(rawValue))
			return dd.isNaN ? 0 : Int(dd)
		}
		
		public static let none			= LogDestination(rawValue: 0)
		public static let console		= LogDestination(rawValue: 1 << 1)
		public static let file			= LogDestination(rawValue: 1 << 2)
		public static let crashlytics	= LogDestination(rawValue: 1 << 3)
		public static let beaverCloud	= LogDestination(rawValue: 1 << 4)
		
		
		public init(rawValue: Int) {
			self.rawValue = rawValue
		}
	}

	class private func _printLog(_ logLevel:SwiftyBeaver.Level, _ items: Any..., context:Any? = nil, separator: String = " ", terminator: String = "\n", file: String = "", function: String = "", line: Int? = nil) {
		
		let filename = URL(fileURLWithPath: file).lastPathComponent.replacingOccurrences(of: "swift", with: "")
		var header = "\(filename):\(function)"
		if let line = line {
			header += "(\(line))"
		}
		header += " : "
		var args: [String] = []
		
		items.forEach({
			args.append("\($0)")
		})
		
		let msg = args.joined(separator: "\n")
		let message = "\(header)\(msg)"
		beaver.custom(level: logLevel, message: message, context: context)
	}
	
	
	
	class func verbose(_ items: Any..., context:Any? = nil, separator: String = " ", terminator: String = "\n", file: String = "", function: String = "", line: Int? = nil) {
		_printLog(.verbose, items, context: context, separator: separator, terminator: terminator, file: file, function: function, line: line)
	}
	
	class func debug(_ items: Any..., context:Any? = nil, separator: String = " ", terminator: String = "\n", file: String = "", function: String = "", line: Int? = nil) {
		_printLog(.debug, items, context: context, separator: separator, terminator: terminator, file: file, function: function, line: line)
	}
	
	class func log(_ items: Any..., context:Any? = nil, separator: String = " ", terminator: String = "\n", file: String = "", function: String = "", line: Int? = nil) {
		_printLog(.info, items, context: context, separator: separator, terminator: terminator, file: file, function: function, line: line)
	}
	
	class func warning(_ items: Any..., context:Any? = nil, separator: String = " ", terminator: String = "\n", file: String = "", function: String = "", line: Int? = nil) {
		_printLog(.warning, items, context: context, separator: separator, terminator: terminator, file: file, function: function, line: line)
	}
	
	class func error(_ items: Any..., context:Any? = nil, separator: String = " ", terminator: String = "\n", file: String = "", function: String = "", line: Int? = nil) {
		_printLog(.error, items, context: context, separator: separator, terminator: terminator, file: file, function: function, line: line)

	}
}



// MARK: - file private
extension LogManager {
	
	/// 초기화.
	///
	/// - Parameter force: true이면 강제 초기화.
	fileprivate static func touch(_ force:Bool = false) {
		// lazy init once. 반드시 한 번 호출해줘야하는 초기화이고, 그 후에는 호출해도 초기화하지 않는 그런 친구여야 함.
		let dests = SwiftyBeaver.self.destinations	// beaver 호출하면 무한루프되므로 호출금지.
		if dests.count > 0 {
			// destination이 있으면 초기화된 것으로 간주.
			// destination을 없게 하고싶으면 NilDestination 추가. (.none)
			if not(force) {
				return
			}
		}
		
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
	
	fileprivate static func _minLogLevel(_ destination:LogDestination? = nil) -> LogLevel? {
		if let dest = destination {
			return LogManager.getDestination(dest)?.minLevel
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
	
	fileprivate static func _setMinLogLevel(_ level:LogLevel, destination:LogDestination? = nil) {
		if let dest = destination {
			if let target = LogManager.getDestination(dest) {
				target.minLevel = level
			}
			return
		}
		for dd in beaver.destinations {
			dd.minLevel = level
		}
		defaultMinLevel = level	// 기본값도 업데이트.
		
	}
	
	
	/// 로깅 대상 설정(초기화. 환경변수 입력)
	fileprivate static func makeDestination(_ destination: LogDestination) -> BaseDestination {
		var manager: BaseDestination!
		let baseLevel = defaultMinLevel
		var format = "$DMM.dd HH:mm:ss.SSS$d $C$L$c: $M"  // full datetime, colored log level and message
		
		switch(destination) {
		case .none:
			manager = NilDestination()
			
		case .console:
			manager = ConsoleDestination()
			format = "$Dmm:ss$d $L: $M"  // hour, minute, second, loglevel and message
			
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
			
			
		case .beaverCloud:
			manager = SBPlatformDestination(appID: SBPlatformConst.appID,
											appSecret: SBPlatformConst.appSecret,
											encryptionKey: SBPlatformConst.encryptionKey)
		default:
			// ERROR
			print("makeDestination Error!")
			break
		}
		// 공통 초기화
		manager.format = format
		manager.minLevel = baseLevel
		
		return manager
	}
	
	
	typealias SequenceOptionSet = OptionSet & Sequence
	
	static func getDestination(_ dest:LogDestination) -> BaseDestination? {
		var manager: BaseDestination!
		var format: String = "$Dyyyy-MM-dd HH:mm:ss.SSS$d $T $L: $M"
		// log thread, date, time in milliseconds, level & message
		
		
		switch(dest) {
		case .none:
			format = ""
			
		case .console:
			manager = ConsoleDestination()
			format = "$Dmm:ss$d $L: $M"  // hour, minute, second, loglevel and message
			
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
			manager = file
			
		case .crashlytics:
			manager = CrashlyticsDestination()
			
			
		case .beaverCloud:
			manager = SBPlatformDestination(appID: SBPlatformConst.appID,
											appSecret: SBPlatformConst.appSecret,
											encryptionKey: SBPlatformConst.encryptionKey)
		default:
			// ERROR
			print("makeDestination Error!")
			break
		}
		
		manager.format = format
		
		return manager
	}
	
}
