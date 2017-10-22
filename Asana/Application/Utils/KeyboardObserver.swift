//
//  KeyboardObserver.swift
//  Asana
//
//  Created by Ilya Puchka on 22/10/2017.
//  Copyright © 2017 Ilya Puchka. All rights reserved.
//

import UIKit

protocol KeyboardObserver: class {
    var keyboardObservers: [Any] { get set }
}

extension KeyboardObserver {
    
    private static func keyboardAnimationDuration(_ note: Notification) -> TimeInterval {
        return note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
    }
    
    private static func keyboardAnimationOptions(_ note: Notification) -> UIViewAnimationOptions {
        return (note.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? UInt).map({
            UIViewAnimationOptions(rawValue: $0 << 16)
        }) ?? UIViewAnimationOptions.curveEaseInOut
    }
    
    func startKeyboardObserving(in scrollView: UIScrollView, onKeyboardAppear: @escaping (Notification) -> Void = { _ in }, onKeyboardDisapear: @escaping (Notification) -> Void = { _ in }) {
        keyboardObservers.append(NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil) { (note) in
            guard let keyboardRect = note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
                return
            }
            
            UIView.animate(
                withDuration: Self.keyboardAnimationDuration(note),
                delay: 0,
                options: Self.keyboardAnimationOptions(note),
                animations: {
                    let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardRect.height, right: 0)
                    scrollView.contentInset = contentInsets
                    scrollView.scrollIndicatorInsets = contentInsets
                    onKeyboardAppear(note)
                    scrollView.layoutIfNeeded()
            })
        })
        
        keyboardObservers.append(NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil) { (note) in
            UIView.animate(
                withDuration: Self.keyboardAnimationDuration(note),
                delay: 0,
                options: Self.keyboardAnimationOptions(note),
                animations: {
                    scrollView.contentInset = .zero
                    scrollView.scrollIndicatorInsets = .zero
                    onKeyboardDisapear(note)
                    scrollView.layoutIfNeeded()
            })
        })
    }
    
    func stopKeyboardObserving() {
        keyboardObservers.forEach({ NotificationCenter.default.removeObserver($0) })
    }
}
