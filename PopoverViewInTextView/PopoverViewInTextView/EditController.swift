//
//  EditController.swift
//  PopoverViewInTextView
//
//  Created by Dongyoung Kwon on 2022/11/04.
//

import UIKit

final class EditController: UIViewController {
    
    private lazy var cancelButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.title = "Cancel"
        barButton.target = self
        barButton.action = #selector(didTapCancel)
        return barButton
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.title = "Done"
        barButton.target = self
        barButton.action = #selector(didTapDone)
        return barButton
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.inputView = nil
        textView.font = .systemFont(ofSize: 17)
        textView.keyboardType = .default
        textView.becomeFirstResponder()
        textView.delegate = self
        return textView
    }()
    
    var str: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationItem.title = "댓글 수정"
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

extension EditController {
    
    @objc
    private func adjustForKeyboard(_ notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        textView.scrollIndicatorInsets = textView.contentInset

        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    
    @objc
    private func didTapCancel() {
        dismiss(animated: true)
    }
    
    @objc
    private func didTapDone() {
        dismiss(animated: true)
    }
}

extension EditController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override var inputAccessoryView: UIView? {
        let view = UIView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
        view.backgroundColor = .yellow
        return view
    }
}

extension EditController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let lastInputStr = (textView.text as NSString).substring(to: textView.selectedRange.location).last,
              lastInputStr == "@",
              let cursorTextRange = textView.selectedTextRange
        else {
            self.presentedViewController?.dismiss(animated: true)
            return
        }
        
        let position = textView.endOfDocument
        let caret = textView.caretRect(for: position)
        
        let firstRect = textView.firstRect(for: cursorTextRange)
        
//        print(caret.origin.y, firstRect.origin.y, view.safeAreaInsets.bottom, textView.safeAreaInsets.bottom, textView.bounds.origin.y)
//        print(textView.frame.origin, textView.bounds.origin)
        
//        guard let a = textView.textRange(from:position, to:position) else { return }
        
//        let b = textView.firstRect(for: a)
        
        let floatingView = FloatingView()
        floatingView.modalPresentationStyle = .popover
        floatingView.preferredContentSize = .init(width: 300, height: 150)
//        floatingView.preferredContentSize = .init(width: firstRect.width, height: firstRect.height)
        floatingView.popoverPresentationController?.sourceView = textView
        floatingView.popoverPresentationController?.permittedArrowDirections = []
        // floatingView.popoverPresentationController?.passthroughViews = [textView]
//        c.popoverPresentationController?.permittedArrowDirections = [.up, .down]
//        c.popoverPresentationController?.sourceRect = .init(x: b.origin.x, y: b.origin.y + 25, width: 300, height: 150)
//        c.popoverPresentationController?.sourceRect = .init(x: caret.origin.x, y: caret.origin.y + 25, width: 300, height: 150)
        
//        floatingView.popoverPresentationController?.sourceRect = firstRect
        
//        print(view.superview?.convert(firstRect.origin, to: nil))
        
        var testBool: Bool = firstRect.height - firstRect.origin.y > 160
        print(firstRect.height, firstRect.origin.y)
//        if firstRect.origin.y > 160 {
        if testBool {
            floatingView.popoverPresentationController?.sourceRect = .init(x: firstRect.origin.x, y: firstRect.origin.y - 150, width: 300, height: 150)
        } else {
            floatingView.popoverPresentationController?.sourceRect = .init(x: firstRect.origin.x, y: firstRect.origin.y + 32, width: 300, height: 150)
        }
        
        floatingView.popoverPresentationController?.delegate = self
        
        
        present(floatingView, animated: true)
//
//
//        let pre = floatingView.popoverPresentationController
//        pre?.delegate = self
//        pre?.sourceView = textView
//        pre?.permittedArrowDirections = .up
//        pre?.sourceRect = textView.bounds
//
//        //            ./floatingView.popoverPresentationController?.sourceRect = .init(x: b.origin.x, y: b.origin.y + 110, width: 200, height: 100)
//        present(floatingView, animated: true)
//        self.popoverPresentationController?.sourceView = floatingView
//        self.popoverPresentationController?.sourceRect = .init(x: b.origin.x, y: b.origin.y + 110, width: 200, height: 100)
        
//        let floatingView = FloatingView(frame: .init(x: b.origin.x, y: b.origin.y + 110, width: 200, height: 100))
//        floatingView.modal
////        let floatingView = FloatingView(frame: b)
//        self.view.addSubview(floatingView)
    }
}

extension EditController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}

