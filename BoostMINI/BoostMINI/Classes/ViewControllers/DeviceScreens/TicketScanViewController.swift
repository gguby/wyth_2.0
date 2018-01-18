//
//  TicketScanViewController.swift
//  BoostMINI
//
//  Created by HS Lee on 10/01/2018.
//Copyright © 2018 IRIVER LIMITED. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import AVFoundation
import Permission
import JuseongJee_RxPermission

class TicketScanViewController: UIViewController {

    // MARK: - * properties --------------------
    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var disposeBag = DisposeBag()
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]

    // MARK: - * IBOutlets --------------------

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var holeView: UIView!
    
    @IBOutlet weak var btnBack: UIButton!
    
    // MARK: - * Initialize --------------------

    override func viewDidLoad() {

        self.initProperties()
        self.initUI()
//        self.prepareViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Permission.camera.rx.permission.subscribe(onNext: { (status: PermissionStatus) in
            switch status {
            case .authorized:   //권한 승인 시
                self.prepareScan()
            case .denied, .disabled: //권한 없을 경우,
                PermissionError.disableCamera.cook()
            default:
                break
            }
        }).disposed(by: self.disposeBag)
    }


    private func initProperties() {
        
    }

    /// ViewController 로딩 시, UIControl 초기화
    private func initUI() {
        self.setMask(with: holeView.frame, in: dimView)
    }


    func prepareViewDidLoad() {
        prepareScan()
    }

    // MARK: - * Main Logic --------------------
    func setMask(with hole: CGRect, in view: UIView) {
        
        // Create a mutable path and add a rectangle that will be h
        let mutablePath = CGMutablePath()
        mutablePath.addRect(view.bounds)
        mutablePath.addRect(hole)
        
        // Create a shape layer and cut out the intersection
        let mask = CAShapeLayer()
        mask.path = mutablePath
        mask.fillRule = kCAFillRuleEvenOdd
        
        // Add the mask to the view
        view.layer.mask = mask
    }
    
    func prepareScan() {
        guard BSTDeviceType.isSimulator == false else {
            BSTFacade.ux.showToast("this is only for device.")
			DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                //goto next view.
                BSTFacade.ux.showToast("1초후에 다음 화면으로 넘어갑니다. 시뮬레이터라서,,")
                BSTError.ticket(TicketError.alreadyRegistred).cookError()
//                self.finishScan(code: "isSimulator")
            }
            return
        }
       
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = cameraView.layer.bounds
        cameraView.layer.addSublayer(videoPreviewLayer!)
        
        self.startScan()
    }
    
    /// a - Description:
    private func startScan() {
        
        // Start video capture.
        captureSession.startRunning()
    }
    
    private func finishScan(code: String) {
        //1. verify barcode to server
        
        //2. if ok, present ticketConfirmViewController
        guard let vc = BSTFacade.ux.instantiateViewController(typeof: TicketConfirmViewController.self) else {
            return
        }
        self.present(vc, animated: true, completion: nil)
    }

    // MARK: - * UI Events --------------------


    // MARK: - * Memory Manage --------------------

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension TicketScanViewController: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            BSTError.ticket(.scanFailed).cookError()
            return
        }
        
        // Get the metadata object.
        if let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
            #if DEBUG
                BSTFacade.ux.showToast("found some codes.")
            #endif
            
            if supportedCodeTypes.contains(metadataObj.type) {
                // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
                if let code = metadataObj.stringValue {
                    self.finishScan(code: code)
                }
            }
        }
        
    }
}
