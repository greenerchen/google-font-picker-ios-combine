//
//  CanvasViewController.swift
//  GoogleFontPicker
//
//  Created by Greener Chen on 2021/4/14.
//

import UIKit
import Combine

class CanvasViewController: UIViewController {
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindFontPicker()
        bindTextView()
        bindKeyboardNotifications()
        textView.becomeFirstResponder()
    }

    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    lazy var fontButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "textformat"), for: .normal)
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(CanvasViewController.showFontPicker), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView(frame: CGRect(x: 50, y: 80, width: 150, height: 80))
        textView.backgroundColor = UIColor.systemTeal
        textView.isEditable = true
        textView.text = "TGIF"
        return textView
    }()
    
    lazy var fontPicker: GoogleFontPicker = {
        let picker = GoogleFontPicker()
        picker.view.translatesAutoresizingMaskIntoConstraints = false
        picker.previewText = textView.text
        return picker
    }()
    
    var fontPickerBottomConstraint: NSLayoutConstraint?
    
    var fontPickerBottomSpace: CGFloat = 0
    
    var fontPickerShown: Bool = false
}

// MARK: - Setup UI
extension CanvasViewController {
    private func setupUI() {
        view.addSubview(fontButton)
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            fontButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            fontButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            fontButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    private func setupFontPicker() {
        fontPickerBottomConstraint = fontPicker.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: fontPickerBottomSpace)
        NSLayoutConstraint.activate([
            fontPicker.view.heightAnchor.constraint(equalToConstant: 120),
            fontPicker.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fontPicker.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            fontPickerBottomConstraint!
        ])
    }
}

// MARK: - Binding
extension CanvasViewController {
    private func bindFontPicker() {
        fontPicker.selectedFont
            .subscribe(on: DispatchQueue.main)
            .sink { [unowned self] (font) in
                self.textView.font = font.withSize(34)
            }
            .store(in: &cancellables)
    }
    
    private func bindTextView() {
        NotificationCenter.default
            .publisher(for: UITextView.textDidChangeNotification, object: textView)
            .compactMap { $0.object as? UITextView }
            .compactMap { $0.text }
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] (text) in
                self.fontPicker.previewText = text
            }
            .store(in: &cancellables)
    }
    
    private func bindKeyboardNotifications() {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [unowned self] (notification) in
                if let userInfo = notification.userInfo,
                   let keyboardBounds: CGRect = userInfo["UIKeyboardBoundsUserInfoKey"] as? CGRect {
                    self.fontPickerBottomSpace = -keyboardBounds.height
                    self.fontPickerBottomConstraint?.constant = -keyboardBounds.height
                }
            }
            .store(in: &cancellables)
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [unowned self] (notification) in
                self.fontPickerBottomSpace = 0
                self.fontPickerBottomConstraint?.constant = 0
            }
            .store(in: &cancellables)
    }
}

// MARK: - Button actions
extension CanvasViewController {
    @objc private func showFontPicker() {
        if !fontPickerShown {
            add(fontPicker)
            setupFontPicker()
        } else {
            fontPicker.remove()
        }
        fontPickerShown = !fontPickerShown
    }
}
