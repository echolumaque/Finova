//
//  UpsertCashflowViewController.swift
//  Finova
//
//  Created by Jhericoh Janquill Lumaque on 4/29/25.
//

import SnapKit
import PhotosUI
import UIKit

protocol UpsertCashflowViewProtocol: AnyObject {
    var presenter: UpsertCashflowPresenter? { get set }
    
    func configureAccountMenuData(_ accounts: [Account])
    func configureCategories(_ categories: [Category])
}

class UpsertCashflowViewController: UIViewController, UpsertCashflowViewProtocol {
    private let horizontalPadding: CGFloat = 20
    private let verticalPadding: CGFloat = 8
    private let cashflowType: CashflowType
    
    var presenter: UpsertCashflowPresenter?
    
    private let mainVStack = UIStackView(frame: .zero)
    private let bottomVStack = UIStackView(frame: .zero)
    private let accountLabel = DynamicLabel(textColor: .secondaryLabel, font: UIFont.preferredFont(for: .body, weight: .regular))
    private let accountBtn = MenuButton(frame: .zero)
    private let categoryLabel = DynamicLabel(textColor: .secondaryLabel, font: UIFont.preferredFont(for: .body, weight: .regular))
    private let categoryBtn = MenuButton(frame: .zero)
    private let selectedPhoto = UIImageView(frame: .zero)
    
    init(cashflowType: CashflowType) {
        self.cashflowType = cashflowType
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = cashflowType.color
        navigationItem.title = cashflowType.rawValue
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        configureMainVStack()
        configureTopSection()
        configureBottomSection()
        configureAccountToUse()
        configureCategory()
        configureDescription()
        configureAttachment()
        configureRepeat()
        configureContinueBtn()
        
        presenter?.viewDidLoad()
    }
    
    private func configureMainVStack() {
        mainVStack.axis = .vertical
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mainVStack)
        mainVStack.pinToEdges(of: view)
    }
    
    private func configureTopSection() {
        let topContainer = UIView(frame: .zero)
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        mainVStack.addArrangedSubview(topContainer)
        topContainer.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        let howMuchLabel = DynamicLabel(textColor: .white.withAlphaComponent(0.4), font: UIFont.preferredFont(for: .title3, weight: .semibold))
        howMuchLabel.text = "How much?"
        topContainer.addSubview(howMuchLabel)
        howMuchLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(horizontalPadding)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview().offset(35)
        }
        
        let valueHStack = UIStackView(frame: .zero)
        valueHStack.axis = .horizontal
        valueHStack.spacing = 1.5
        valueHStack.translatesAutoresizingMaskIntoConstraints = false
        topContainer.addSubview(valueHStack)
        valueHStack.snp.makeConstraints { make in
            make.top.equalTo(howMuchLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        let currencyLabel = DynamicLabel(textColor: .white, font: UIFont.preferredFont(for: .extraLargeTitle, weight: .bold))
        currencyLabel.text = "$"
        
        let valueTextField = UITextField(frame: .zero)
        valueTextField.keyboardType = .decimalPad
        
        valueTextField.font = UIFont.preferredFont(for: .extraLargeTitle, weight: .bold)
        valueTextField.textColor = .white
        valueTextField.adjustsFontSizeToFitWidth = true
        valueTextField.adjustsFontForContentSizeCategory = true
        valueTextField.inputAccessoryView = textFieldToolbar {
            print("text: \(valueTextField.text)")
        }
        
        valueTextField.placeholder = "0"
        valueTextField.delegate = self
        
        valueHStack.addArrangedSubviews(currencyLabel, valueTextField)
    }
    
    private func configureBottomSection() {
        bottomVStack.axis = .vertical
        bottomVStack.spacing = 40
        bottomVStack.backgroundColor = .systemBackground
        // More reference: https://stackoverflow.com/questions/77475103/traitcollectiondidchange-was-deprecated-in-ios-17-0-how-do-i-use-the-replacem
//        bottomVStack.backgroundColor = UIScreen.main.traitCollection.userInterfaceStyle == .light ? .systemBackground : .secondarySystemBackground
//        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, previousTraitCollection: UITraitCollection) in
//            self.bottomVStack.backgroundColor = switch self.traitCollection.userInterfaceStyle {
//            case .light: .systemBackground
//            case .dark: .secondarySystemBackground
//            default: .systemBackground
//            }
//        }
        bottomVStack.clipsToBounds = true
        bottomVStack.layer.cornerRadius = 30
        bottomVStack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomVStack.layoutMargins = UIEdgeInsets(top: 40, left: horizontalPadding, bottom: 0, right: horizontalPadding)
        bottomVStack.isLayoutMarginsRelativeArrangement = true
        
        mainVStack.addArrangedSubview(bottomVStack)
        bottomVStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    private func configureAccountToUse() {
        let accountStackView = UIStackView(frame: .zero)
        accountStackView.axis = .horizontal
        
        accountStackView.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        accountStackView.isLayoutMarginsRelativeArrangement = true
        
        accountStackView.layer.cornerRadius = 16
        accountStackView.layer.borderWidth = 0.5
        accountStackView.layer.borderColor = UIColor.separator.cgColor
        
        bottomVStack.addArrangedSubview(accountStackView)
        accountStackView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.085)
        }
        
        accountLabel.text = "Account"
        
        let config = UIImage.SymbolConfiguration(font: UIFont.preferredFont(for: .callout, weight: .regular))
        let chevronDown = UIImageView(image: UIImage(systemName: "chevron.down", withConfiguration: config))
        chevronDown.contentMode = .scaleAspectFit
        chevronDown.tintColor = .secondaryLabel
        accountStackView.addArrangedSubviews(accountLabel, SpacerView(), chevronDown)
        
        accountBtn.anchorView = accountLabel
        accountBtn.contentHorizontalAlignment = .leading
        accountBtn.showsMenuAsPrimaryAction = true
        accountStackView.addSubviews(accountBtn)
        accountBtn.pinToEdges(of: accountStackView)
        accountStackView.bringSubviewToFront(accountBtn)
    }
    
    private func configureCategory() {
        let categoryStackView = UIStackView(frame: .zero)
        categoryStackView.axis = .horizontal
        
        categoryStackView.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        categoryStackView.isLayoutMarginsRelativeArrangement = true
        
        categoryStackView.layer.cornerRadius = 16
        categoryStackView.layer.borderWidth = 0.5
        categoryStackView.layer.borderColor = UIColor.separator.cgColor
        
        bottomVStack.addArrangedSubviews(categoryStackView)
        categoryStackView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.085)
        }
        
        categoryLabel.text = "Category"
        
        let config = UIImage.SymbolConfiguration(font: UIFont.preferredFont(for: .callout, weight: .regular))
        let chevronDown = UIImageView(image: UIImage(systemName: "chevron.down", withConfiguration: config))
        chevronDown.contentMode = .scaleAspectFit
        chevronDown.tintColor = .secondaryLabel
        categoryStackView.addArrangedSubviews(categoryLabel, SpacerView(), chevronDown)
        
        
        categoryBtn.anchorView = categoryLabel
        categoryBtn.contentHorizontalAlignment = .leading
        categoryBtn.showsMenuAsPrimaryAction = true
        categoryStackView.addSubview(categoryBtn)
        categoryBtn.pinToEdges(of: categoryStackView)
        categoryStackView.bringSubviewToFront(categoryBtn)
    }
    
    private func configureDescription() {
        let descriptionTextView = UITextView(frame: .zero)
        descriptionTextView.delegate = self
        descriptionTextView.spellCheckingType = .no
        descriptionTextView.autocorrectionType = .no
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        descriptionTextView.inputAccessoryView = textFieldToolbar {
            
        }
        
        descriptionTextView.layer.cornerRadius = 16
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor.separator.cgColor
        
        descriptionTextView.font = UIFont.preferredFont(for: .body, weight: .regular)
        descriptionTextView.textColor = .label
        descriptionTextView.text = "Description"
        descriptionTextView.textColor = .secondaryLabel
        
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        bottomVStack.addArrangedSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.15)
        }
    }
    
    private func configureAttachment() {
        let dashedBorder = DashedBorderView(color: .separator)
        dashedBorder.layer.cornerRadius = 16
        bottomVStack.addArrangedSubview(dashedBorder)
        dashedBorder.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.085)
        }
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "paperclip")
        config.title = "Add attachment"
        config.imagePlacement = .leading
        config.imagePadding = 10
        
        let labelButton = UIButton(configuration: config)
        labelButton.tintColor = .secondaryLabel
        labelButton.isUserInteractionEnabled = true
        
        let takePhotoAction = UIAction(title: "Take Photo", image: UIImage(systemName: "camera")) { [weak self] _ in
            guard let self else { return }
            Task { [weak self] in
                guard let self else { return }
                Task { [weak self] in
                    guard let self, let camera = await configureCamera() else { return }
                    present(camera, animated: true)
                }
            }
        }
        
        let imagePicker = configurePhotoLibrary()
        let photoLibraryAction = UIAction(title: "Photo Library", image: UIImage(systemName: "photo.on.rectangle.angled")) { [weak self] _ in
            guard let self else { return }
            present(imagePicker, animated: true)
        }
        let menu = UIMenu(children: [photoLibraryAction, takePhotoAction])
        labelButton.menu = menu
        labelButton.showsMenuAsPrimaryAction = true
        
        labelButton.translatesAutoresizingMaskIntoConstraints = false
        dashedBorder.addSubview(labelButton)
        labelButton.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        selectedPhoto.translatesAutoresizingMaskIntoConstraints = false
        selectedPhoto.isHidden = true
    }
    
    private func configureRepeat() {
        
    }
    
    private func configureContinueBtn() {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.baseBackgroundColor = cashflowType.color
        config.baseForegroundColor = .white
        config.buttonSize = .large
        config.title = "Continue"
        
        let continueBtn = UIButton(configuration: config, primaryAction: nil)
        bottomVStack.addArrangedSubviews(SpacerView(), continueBtn)
    }
    
    func configureAccountMenuData(_ accounts: [Account]) {
        let actions = accounts.map { account in
            UIAction(title: account.name ?? "") { [weak self] _ in
                guard let self else { return }
                presenter?.selectAccount(account)
                accountLabel.text = account.name ?? ""
                if accountLabel.textColor != .label { accountLabel.textColor = .label }
            }
        }
        
        let menu = UIMenu(options: .singleSelection, children: actions)
        accountBtn.menu = menu
    }
    
    func configureCategories(_ categories: [Category]) {
        let actions = categories.map { category in
            UIAction(title: category.name ?? "") { [weak self] _ in
                guard let self else { return }
                presenter?.selectCategory(category)
                categoryLabel.text = category.name ?? ""
                if categoryLabel.textColor != .label { categoryLabel.textColor = .label }
            }
        }
        
        let menu = UIMenu(options: .singleSelection, children: actions)
        categoryBtn.menu = menu
    }
    
    private func configureCamera() async -> UIImagePickerController? {
        let camera = UIImagePickerController()
        camera.sourceType = .camera
        camera.cameraCaptureMode = .photo
        camera.showsCameraControls = true
        camera.allowsEditing = true
        camera.delegate = self
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: return camera
        case .denied, .restricted: return nil
        case .notDetermined:
            let canAcessCaptureDevice = await AVCaptureDevice.requestAccess(for: .video)
            return canAcessCaptureDevice ? camera : nil
        @unknown default: return nil
        }
    }
    
    private func configurePhotoLibrary() -> PHPickerViewController {
        var phPickerConfig = PHPickerConfiguration(photoLibrary: .shared())
        phPickerConfig.selectionLimit = 1
        phPickerConfig.filter = .images
        
        let imagePicker = PHPickerViewController(configuration: phPickerConfig)
        imagePicker.delegate = self
        
        return imagePicker
    }
}

extension UpsertCashflowViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        guard let presenter else { return false }
        return presenter.validateValueIfDecimal(value: newText)
    }
}

extension UpsertCashflowViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .secondaryLabel {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = .secondaryLabel
        }
    }
}

extension UpsertCashflowViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider else { return }
        if !itemProvider.canLoadObject(ofClass: UIImage.self) { return }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            if error != nil { return }
            guard let self, let selectedImage = image as? UIImage else { return }
            
            DispatchQueue.main.async {
                self.selectedPhoto.isHidden = false
                self.selectedPhoto.image = selectedImage
                self.bottomVStack.addArrangedSubview(self.selectedPhoto)
            }
        }
    }
}

extension UpsertCashflowViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

#Preview {
    UpsertCashflowViewController(cashflowType: .credit)
}
