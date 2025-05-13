//
//  UpsertCashflowRouter.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/29/25.
//

import UIKit
import PhotosUI
import Swinject

typealias UpsertCashflowEntryPoint = UpsertCashflowViewProtocol & UIViewController

protocol UpsertCashflowRouter: AnyObject {
    var view: UpsertCashflowEntryPoint? { get }
    
    func presentCamera() async
    func presentPhotoLibrary()
    func onTxnUpsert() async
}

class UpsertCashflowRouterImpl: UpsertCashflowRouter {
    weak var view: UpsertCashflowEntryPoint? { upsertCashflowViewController }
    var upsertCashflowViewController: UpsertCashflowEntryPoint?
    
    func presentCamera() async {
        let camera: (authStatus: AVAuthorizationStatus, actual: UIImagePickerController) = await MainActor.run {
            let camera = UIImagePickerController()
            camera.sourceType = .camera
            camera.cameraCaptureMode = .photo
            camera.showsCameraControls = true
            camera.allowsEditing = true
            camera.delegate = (view as? UINavigationControllerDelegate & UIImagePickerControllerDelegate)
            
            return (AVCaptureDevice.authorizationStatus(for: .video), camera)
        }
        
        if camera.authStatus == .authorized {
            await view?.present(camera.actual, animated: true)
        } else if camera.authStatus == .notDetermined {
            if await AVCaptureDevice.requestAccess(for: .video) {
                await view?.present(camera.actual, animated: true)
            }
        }
    }
    
    func presentPhotoLibrary() {
        guard let view else { return }
       
        var phPickerConfig = PHPickerConfiguration(photoLibrary: .shared())
        phPickerConfig.selectionLimit = 1
        phPickerConfig.filter = .images
        
        let imagePicker = PHPickerViewController(configuration: phPickerConfig)
        imagePicker.delegate = (view as? PHPickerViewControllerDelegate)
        view.present(imagePicker, animated: true)
    }
    
    func onTxnUpsert() async {
        _ = await MainActor.run { view?.navigationController?.popViewController(animated: true) }
    }
}
