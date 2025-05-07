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
    func displayAttachment(_ image: UIImage, at index: Int) async
}

class UpsertCashflowViewController: UIViewController, UpsertCashflowViewProtocol {
    private let horizontalPadding: CGFloat = 20
    private let verticalPadding: CGFloat = 8
    private let cashflowType: CashflowType
    private var selectedAssetIdentifier: [String] = []
    
    var presenter: UpsertCashflowPresenter?
    
    private let mainVStack = UIStackView(frame: .zero)
    private let bottomVStack = UIStackView(frame: .zero)
    private let valueTextField = UITextField(frame: .zero)
    private let accountLabel = DynamicLabel(textColor: .secondaryLabel, font: UIFont.preferredFont(for: .body, weight: .regular))
    private let accountBtn = MenuButton(frame: .zero)
    private let categoryLabel = DynamicLabel(textColor: .secondaryLabel, font: UIFont.preferredFont(for: .body, weight: .regular))
    private let categoryBtn = MenuButton(frame: .zero)
    private let descriptionTextView = UITextView(frame: .zero)
    private let dashedBorder = DashedBorderView(color: .separator)
    private var selectedPhoto = UIImageView(frame: .zero)
    private var addAttachmentView = AddAttachmentView(menu: UIMenu())
    private var imagePicker = PHPickerViewController(configuration: .init())
    
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
        configureSelectedAttachments()
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
        
        valueTextField.keyboardType = .decimalPad
        
        valueTextField.font = UIFont.preferredFont(for: .extraLargeTitle, weight: .bold)
        valueTextField.textColor = .white
        valueTextField.adjustsFontSizeToFitWidth = true
        valueTextField.adjustsFontForContentSizeCategory = true
        valueTextField.inputAccessoryView = textFieldToolbar { [weak self] in
            guard let self, let presenter else { return }
            let parsedValue = Double(valueTextField.text ?? "") ?? .zero
            presenter.didFinishedEnteringValue(value: parsedValue)
        }
        
        valueTextField.placeholder = "0"
        valueTextField.delegate = self
        
        valueHStack.addArrangedSubviews(currencyLabel, valueTextField)
    }
    
    private func configureBottomSection() {
        bottomVStack.axis = .vertical
        bottomVStack.spacing = 16
        bottomVStack.backgroundColor = .systemBackground
        bottomVStack.alignment = .leading
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
            make.horizontalEdges.equalToSuperview { $0.layoutMarginsGuide.snp.horizontalEdges }
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
            make.horizontalEdges.equalToSuperview { $0.layoutMarginsGuide.snp.horizontalEdges }
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
        descriptionTextView.delegate = self
        descriptionTextView.spellCheckingType = .no
        descriptionTextView.autocorrectionType = .no
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        descriptionTextView.inputAccessoryView = textFieldToolbar { [weak self] in
            guard let self, let presenter else { return }
            presenter.didFinishedEnteringDescription(description: descriptionTextView.text)
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
            make.horizontalEdges.equalToSuperview { $0.layoutMarginsGuide.snp.horizontalEdges }
        }
    }
    
    private func configureAttachment() {
        dashedBorder.layer.cornerRadius = 16
        bottomVStack.addArrangedSubview(dashedBorder)
        dashedBorder.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.085)
            make.horizontalEdges.equalToSuperview { $0.layoutMarginsGuide.snp.horizontalEdges }
        }
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "paperclip")
        config.title = "Add attachment"
        config.imagePlacement = .leading
        config.imagePadding = 10
        
        let labelButton = UIButton(configuration: config)
        labelButton.tintColor = .secondaryLabel
        labelButton.isUserInteractionEnabled = true
        
        let menu = UIMenu(children: [])
        labelButton.menu = menu
        labelButton.showsMenuAsPrimaryAction = true
        
        labelButton.translatesAutoresizingMaskIntoConstraints = false
        dashedBorder.addSubview(labelButton)
        labelButton.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func configureRepeat() {
        
    }
    
    private func configureSelectedAttachments() {
        let takePhotoAction = UIAction(title: "Take Photo", image: UIImage(systemName: "camera")) { [weak self] _ in
            guard let self else { return }
            Task { [weak self] in
                guard let self else { return }
                Task { [weak self] in
                    guard let self, let presenter else { return }
                    await presenter.presentCamera()
                }
            }
        }
        
        let photoLibraryAction = UIAction(title: "Photo Library", image: UIImage(systemName: "photo.on.rectangle.angled")) { [weak self] _ in
            guard let self, let presenter else { return }
            presenter.presentPhotoLibrary()
        }
        let menu = UIMenu(children: [photoLibraryAction, takePhotoAction])
        addAttachmentView = AddAttachmentView(menu: menu)
        
        bottomVStack.addArrangedSubviews(addAttachmentView)
        addAttachmentView.snp.makeConstraints { $0.width.equalTo(addAttachmentView.snp.height) }
    }
    
    private func configureContinueBtn() {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.baseBackgroundColor = cashflowType.color
        config.baseForegroundColor = .white
        config.buttonSize = .large
        config.title = "Continue"
        
        let continueBtn = UIButton(configuration: config, primaryAction: UIAction { [weak self] _ in
            guard let self, let presenter else { return }
            presenter.didTapContinue()
        })
        bottomVStack.addArrangedSubview(continueBtn)
        continueBtn.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview { $0.layoutMarginsGuide.snp.horizontalEdges }
            make.height.equalTo(54)
        }
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
    
    func displayAttachment(_ image: UIImage, at index: Int) async {
        await MainActor.run {
            guard let oldViewIndex = bottomVStack.arrangedSubviews.firstIndex(of: addAttachmentView) else { return }
            
            bottomVStack.removeArrangedSubview(addAttachmentView)
            addAttachmentView.removeFromSuperview()
            
            let container = UIView(frame: .zero)
            container.layer.cornerRadius = 8
            container.clipsToBounds = true
            container.translatesAutoresizingMaskIntoConstraints = false
            
            bottomVStack.insertArrangedSubview(container, at: oldViewIndex)
            container.snp.makeConstraints { $0.height.equalTo(container.snp.width) }
            
            selectedPhoto = UIImageView(image: image)
            selectedPhoto.layer.cornerRadius = 8
            selectedPhoto.clipsToBounds = true
            selectedPhoto.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(selectedPhoto)
            selectedPhoto.snp.makeConstraints { $0.edges.equalToSuperview() }
            
            var closeBtnConfig = UIButton.Configuration.plain()
            closeBtnConfig.image = UIImage(systemName: "xmark.circle.fill")
            closeBtnConfig.baseForegroundColor = .systemGray
            closeBtnConfig.buttonSize = .mini
            
            let action = UIAction { [weak self] _ in
                guard let self, let containerViewIndex = bottomVStack.arrangedSubviews.firstIndex(of: container) else { return }
                imagePicker.deselectAssets(withIdentifiers: selectedAssetIdentifier)
                selectedAssetIdentifier.removeFirst()
                selectedPhoto.image = nil
                bottomVStack.removeArrangedSubview(container)
                container.removeFromSuperview()
                bottomVStack.insertArrangedSubview(addAttachmentView, at: containerViewIndex)
            }
            
            let closeBtn = UIButton(configuration: closeBtnConfig, primaryAction: action)
            closeBtn.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(closeBtn)
            container.bringSubviewToFront(closeBtn)
            closeBtn.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(-10)
                make.top.equalToSuperview()
            }
        }
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
        presenter?.didFinishedEnteringDescription(description: textView.text)
    }
}

extension UpsertCashflowViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        presenter?.didPickAttachments(results)
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
