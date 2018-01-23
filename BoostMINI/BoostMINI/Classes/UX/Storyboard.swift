//
//  Storyboard.swift
//  radar
//
//  Created by Jason Lee on 27/03/2017.
//  Copyright © 2017 JasonDevelop. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case LaunchScreen
    case Main
    case Home
    case SignUp
    case Device
    case Notfication
    case BTDevice

    
    /// 해당 ViewController Type을 스토리보드에서 인스턴스로 만들어 반환함.
    /// Storyboard에 ViewController Type, Storyboard Id를 클래스명과 동일하게 작성.
    ///
    /// - Parameters:
    ///   - viewController: UIViewController Type
    ///   - bundle: nil
    /// - Returns: UIViewController Type
    public func instantiate<VC: UIViewController>(_ viewController: VC.Type,
                            inBundle bundle: Bundle? = nil) -> VC {
        guard let vc = UIStoryboard(name: self.rawValue, bundle: bundle)
                .instantiateViewController(withIdentifier: VC.storyboardIdentifier) as? VC
            else {
                fatalError("Couldn't instantiate \(VC.storyboardIdentifier) from \(self.rawValue)")
                
        }
        
        return vc
    }
    
    public func instantiate(_ storyboardIdentifier: String,
                            inBundle bundle: Bundle? = nil) -> UIViewController {
        return UIStoryboard(name: self.rawValue, bundle: bundle).instantiateViewController(withIdentifier: storyboardIdentifier)
    }
}

extension UIViewController {
    
    public static var defaultNib: String {
        return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
    }
    
    public static var storyboardIdentifier: String {
        return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
    }
}


protocol BSTUXProtocol {
    func find(className: String) -> Bool
}

//extension BSTUXProtocol where Self == BSTScreens.Main {
//
//    func find(className: String) -> Bool {
//        return self.rawValue == className
//    }
//}

enum BSTScreens {
    
    case main(Main)
    case home(Home)
//    case signUp(SignUp)
    case device(Device)
    case btDevice(BTDevice)
//    case notfication(Notfication)
//    case common(Common)
    
    
    enum Main: String, BSTUXProtocol {
        case intro = "IntroViewController"
        
        func find(className: String) -> Bool {
            return self.rawValue == className
        }
    }
    
    enum Home: String, BSTUXProtocol {
       case help = "HelpWebViewController"
       case DetailConcert = "DetailConcertInformationViewController"
        
        func find(className: String) -> Bool {
            return self.rawValue == className
        }
    }
    
    enum Device: String, BSTUXProtocol {
        case ticketScan = "TicketScanViewController"
        case ticketConfirm = "TicketConfirmViewController"
        
        func find(className: String) -> Bool {
            return self.rawValue == className
        }
    }
    
    enum BTDevice: String, BSTUXProtocol {
        case btDeviceScan = "BTDeviceViewController"
        
        func find(className: String) -> Bool {
            return self.rawValue == className
        }
    }
    
    enum Common: String, BSTUXProtocol {
        case alert = "AlertViewController"
        case tableAlert = "TableAlertViewController"
        case progress = "ProgressPopViewController"
        case login = "LoginPopViewController"
        case join = "JoinPopViewController"
        
        func find(className: String) -> Bool {
            return self.rawValue == className
        }
    }
    

    static func instantiate(withClassName className: String) -> UIViewController? {
        var screen: BSTScreens?
        if let main = Main.init(rawValue: className) {
            screen = BSTScreens.main(main)
        } else if let device = Device.init(rawValue: className) {
            screen = BSTScreens.device(device)
        } else if let btDevice = BTDevice.init(rawValue: className) {
            screen = BSTScreens.btDevice(btDevice)
        } else if let home = Home.init(rawValue: className) {
            screen = BSTScreens.home(home)
        }
        
        return screen?.instantiate()
    }
    
    private func instantiate() -> UIViewController {
        var vc: UIViewController! = nil
        
        switch self {
        case let .main(identifier):
            vc = Storyboard.Main.instantiate(identifier.rawValue)
        case let .device(identifier):
            vc = Storyboard.Device.instantiate(identifier.rawValue)
        case let .home(identifier):
            vc = Storyboard.Home.instantiate(identifier.rawValue)
        case let .btDevice(identifier):
            vc = Storyboard.BTDevice.instantiate(identifier.rawValue)
//        case let .common(identifier):
//            vc = Storyboard.Common.instantiate(identifier.rawValue)
        }
        
        return vc
    }
}






