//
//  MyTextView.swift
//  kbdshortcuts
//
//  Created by l2dy on 3/17/24.
//

import UIKit

class MyTextView : UITextView {
    override func becomeFirstResponder() -> Bool {
        let res = super.becomeFirstResponder()

        print("DEBUG: hit becomeFirstResponder()")
        
        // Initial state
        smartDashesType = UITextSmartDashesType.no
        smartQuotesType = UITextSmartQuotesType.no
        autocorrectionType = UITextAutocorrectionType.no
        autocapitalizationType = UITextAutocapitalizationType.none
        spellCheckingType = UITextSpellCheckingType.no
        smartInsertDeleteType = UITextSmartInsertDeleteType.no
        inlinePredictionType = UITextInlinePredictionType.no
        
        let item = inputAssistantItem
        item.trailingBarButtonGroups = []
        item.leadingBarButtonGroups = []
        
        return res
    }

    var isHKB: Bool = true

    func updateIAIByKeyboardHeight(height: CGFloat) {
        if isHKB != (height < 150) {
            print("DEBUG: applying isHKB change")
            isHKB = height < 150
            if height < 150 {
                // assume hardware keyboard connected
                let item = inputAssistantItem
                item.trailingBarButtonGroups = []
                item.leadingBarButtonGroups = []
            } else {
                // otherwise
                let item = inputAssistantItem
                let itemOne = UIBarButtonItem(
                    title: "One",
                    style: .plain,
                    target: self,
                    action: #selector(noOp))
                let itemChoose = UIBarButtonItem(
                    title: "Choose",
                    style: .plain,
                    target: nil,
                    action: nil)
                let group = UIBarButtonItemGroup(
                    barButtonItems: [itemOne],
                    representativeItem: itemChoose)
                item.leadingBarButtonGroups = [group]
            }
        }
    }

    @objc private func noOp() {}

    @objc private func _keyboardWillShow(notifination: Notification) {
        print("_keyboardWillShow called(), lC=\(inputAssistantItem.leadingBarButtonGroups.count), tC=\(inputAssistantItem.trailingBarButtonGroups.count)")
        guard let kbEndFrame = notifination.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        print("keyboardFrame height", kbEndFrame.height)
        updateIAIByKeyboardHeight(height: kbEndFrame.height)
    }

    @objc private func _keyboardWillHide(notifination: Notification) {
        print("_keyboardWillHide called()")
        guard let kbEndFrame = notifination.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        print("keyboardFrame height", kbEndFrame.height)
        updateIAIByKeyboardHeight(height: kbEndFrame.height)
    }

    func register() {
        // Register for keyboard notifications
        let nc = NotificationCenter.default
        nc.addObserver(
            self,
            selector: #selector(_keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        nc.addObserver(
            self,
            selector: #selector(_keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)

    }
}
