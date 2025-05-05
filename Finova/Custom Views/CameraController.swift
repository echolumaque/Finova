//
//  CameraController.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 5/6/25.
//

import AVFoundation
import UIKit

class CameraController: UIImagePickerController {
    override func viewDidLoad() {
        super.viewDidLoad()
        sourceType = .camera
        cameraCaptureMode = .photo
        showsCameraControls = true
        allowsEditing = true
    }
    
    static func checkCameraAuthorizationStatus() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: return true
        case .denied, .restricted: return false
        case .notDetermined:
            let canAcessCaptureDevice = await AVCaptureDevice.requestAccess(for: .video)
            return canAcessCaptureDevice
        @unknown default: return false
        }
    }
}
