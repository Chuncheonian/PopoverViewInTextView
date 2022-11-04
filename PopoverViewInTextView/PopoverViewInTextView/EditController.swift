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
        textView.text = "기존의 댓글"
        return textView
    }()
    
    private var keyboardHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension EditController {
    @objc
    private func adjustForKeyboard(_ notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        keyboardHeight = keyboardViewEndFrame.height
        
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
              let cursorTextRange = textView.selectedTextRange,
              let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else {
            self.presentedViewController?.dismiss(animated: true)
            return
        }
        
        let naviBarHeight: CGFloat = self.navigationController?.navigationBar.frame.height ?? 56
        let sentenceHeight: CGFloat = 20
        
        let firstRect = textView.firstRect(for: cursorTextRange)
        
        let floatingView = FloatingView()
        let floatingViewWidth: CGFloat = textView.frame.width * 0.84
        let floatingViewHeight: CGFloat = (textView.frame.height - keyboardHeight - sentenceHeight) * 0.48
        
        floatingView.preferredContentSize = .init(width: floatingViewWidth, height: floatingViewHeight)
        floatingView.modalPresentationStyle = .popover
        floatingView.popoverPresentationController?.delegate = self
        floatingView.popoverPresentationController?.sourceView = textView
        
        /// 말풍선 arrow 삭제
        floatingView.popoverPresentationController?.permittedArrowDirections = []
        // floatingView.popoverPresentationController?.canOverlapSourceViewRect = true
        
        /// navi 모달 스타일이 pageSheet일 때 12(기기마다 달라짐;)를 줘야 된다.
        floatingView.popoverPresentationController?.popoverLayoutMargins = .init(
            top: naviBarHeight,
            left: window.directionalLayoutMargins.leading * 2,
            bottom: -window.safeAreaInsets.bottom,
            right: window.directionalLayoutMargins.trailing * 2
        )
        
        /// scroll 해도 popUpView 안사라짐
        // floatingView.popoverPresentationController?.passthroughViews = [textView]
        
        // TODO: 재 수정 해야됨
        let isPopoverViewDownPosition: Bool = (firstRect.origin.y - textView.contentOffset.y) < (textView.frame.height - keyboardHeight - floatingViewHeight)
        
        floatingView.popoverPresentationController?.popoverBackgroundViewClass = PopoverbackgroundView.self
        
        let cursorPopoverViewSpacing: CGFloat = 5
        
        if isPopoverViewDownPosition {
            floatingView.popoverPresentationController?.sourceRect = .init(x: firstRect.origin.x, y: firstRect.origin.y + sentenceHeight + cursorPopoverViewSpacing, width: floatingViewWidth, height: floatingViewHeight)
        } else {
            floatingView.popoverPresentationController?.sourceRect = .init(x: firstRect.origin.x, y: firstRect.origin.y - cursorPopoverViewSpacing, width: floatingViewWidth, height: -floatingViewHeight)
        }
        
        present(floatingView, animated: true)
    }
}

extension EditController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension EditController {
    private func setUpUI() {
        setUpView()
        setUpNavi()
        setUpComponents()
    }
    
    private func setUpView() {
        view.backgroundColor = .white
    }
    
    private func setUpNavi() {
        navigationItem.title = "댓글 수정"
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func setUpComponents() {
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.readableContentGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.readableContentGuide.bottomAnchor),
            textView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
        ])
    }
}
