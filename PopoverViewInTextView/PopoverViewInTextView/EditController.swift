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
        self.presentedViewController?.dismiss(animated: true)
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
        
        // let position = textView.endOfDocument
        // let caret = textView.caretRect(for: position)
        
        let firstRect = textView.firstRect(for: cursorTextRange)
        
        let floatingView = FloatingView()
        let floatingViewWidth: CGFloat = 300
        let floatingViewHeight: CGFloat = 150
        floatingView.preferredContentSize = .init(width: floatingViewWidth, height: floatingViewHeight)
        floatingView.modalPresentationStyle = .popover
        floatingView.popoverPresentationController?.sourceView = textView
        
        /// 말풍선 arrow 삭제
        floatingView.popoverPresentationController?.permittedArrowDirections = []
//        floatingView.popoverPresentationController?.canOverlapSourceViewRect = true
        
        /// bottom 44는 navigationbar Height
        /// top 44는 navi 모달 스타일이 fullScreent일 때 충족
        /// 반면, navi 모달 스타일이 pageSheet일 때 top 마진을 67 줘야된다
        floatingView.popoverPresentationController?.popoverLayoutMargins = .init(top: 67, left: 16, bottom: -44, right: 16)
        
        /// scroll 해도 popUpView 안사라짐
        //floatingView.popoverPresentationController?.passthroughViews = [textView]
        
        let sentenceHeight: CGFloat = 55
        
        var isUpPosition: Bool
        
        // TODO: 165도 floatingView Height와 textView Height에 맞춰서 변경해야됨
        if textView.contentOffset.y == 0 {
            isUpPosition = firstRect.origin.y < 165
        } else {
            isUpPosition = (firstRect.origin.y - textView.contentOffset.y) < 165
        }
        
        if isUpPosition {
            floatingView.popoverPresentationController?.sourceRect = .init(x: firstRect.origin.x, y: firstRect.origin.y, width: floatingViewWidth, height: floatingViewHeight + sentenceHeight)
        } else {
            // TODO: 10에 의미있는 값을 넣어야되는데.....
            floatingView.popoverPresentationController?.sourceRect = .init(x: firstRect.origin.x, y: firstRect.origin.y, width: floatingViewWidth, height: -floatingViewHeight + 10)
        }
        
        floatingView.popoverPresentationController?.delegate = self
        
        present(floatingView, animated: true)
    }
}

extension EditController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}
