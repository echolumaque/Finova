//
//  UpsertCashflowPresenter.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/29/25.
//

import Foundation
import PhotosUI

protocol UpsertCashflowPresenter: AnyObject {
    var router: UpsertCashflowRouter? { get set }
    var interactor: UpsertCashflowInteractor? { get set }
    var view: UpsertCashflowViewProtocol? { get set }
    
    func viewDidLoad()
    func didFinishedEnteringValue(value: Double)
    func validateValueIfDecimal(value: String) -> Bool
    func selectAccount(_ account: Account)
    func selectCategory(_ category: Category)
    func didFinishedEnteringDescription(description: String)
    func getCameraController() async -> CameraController?
    func presentCamera() async
    func presentPhotoLibrary()
    func didPickAttachments(_ results: [PHPickerResult])
    func didRemoveAttachment(at index: Int)
    func didTapContinue()
}

class UpsertCashflowPresenterImpl: UpsertCashflowPresenter {
    var router: (any UpsertCashflowRouter)?
    var interactor: (any UpsertCashflowInteractor)?
    weak var view: UpsertCashflowViewProtocol?
    
    private var selectedAssetIdentifiers: [String] = []
    
    func viewDidLoad() {
        Task {
            let accounts = await interactor?.getAccounts() ?? []
            let categories = await interactor?.getCategories() ?? []
            await MainActor.run {
                view?.configureAccountMenuData(accounts)
                view?.configureCategories(categories)
            }
        }
    }
    
    func didFinishedEnteringValue(value: Double) {
        
    }
    
    func validateValueIfDecimal(value: String) -> Bool {
        let decimalSeparator = Locale.current.decimalSeparator ?? "."
        let separatorEscaped = NSRegularExpression.escapedPattern(for: decimalSeparator)
        let pattern = "^\\d*(?:\(separatorEscaped)\\d{0,2})?$"
        
        return value.range(of: pattern, options: .regularExpression) != nil
    }
    
    func selectAccount(_ account: Account) {
        interactor?.selectAccount(account)
    }
    
    func selectCategory(_ category: Category) {
        interactor?.selectCategory(category)
    }
    
    func didFinishedEnteringDescription(description: String) {
        
    }
    
    func getCameraController() async -> CameraController? {
        let isAuthorized = await CameraController.checkCameraAuthorizationStatus()
        return await isAuthorized ? CameraController() : nil
    }
    
    func presentCamera() async {
        await router?.presentCamera()
    }
    
    func presentPhotoLibrary() {
        router?.presentPhotoLibrary()
    }
    
    func didPickAttachments(_ results: [PHPickerResult]) {
        Task {
            guard let itemProvider = results.first?.itemProvider,
                  itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
            
            do {
                guard let image = try await interactor?.loadImage(from: itemProvider) else { return }
                await view?.displayAttachment(image, at: 0)
            } catch {
                
            }
        }
    }
    
    func didRemoveAttachment(at index: Int) {
        
    }
    
    func didTapContinue() {
        
    }
}
