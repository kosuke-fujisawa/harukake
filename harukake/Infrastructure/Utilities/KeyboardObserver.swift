//
//  KeyboardObserver.swift
//  harukake
//
//  このプロジェクトは CC BY-NC 4.0 ライセンスの下でライセンスされています。
//  プロジェクトルートのLICENSEファイルで完全なライセンス情報を参照してください。
//
//  非営利使用のみ。
//

import UIKit
import Combine

/// キーボードの表示・非表示を監視し、キーボードの高さを通知するユーティリティクラス
/// FABやその他のUI要素がキーボードで隠れないよう位置調整に使用される
final class KeyboardObserver: ObservableObject {
    static let shared = KeyboardObserver()
    
    private let subject = PassthroughSubject<CGFloat, Never>()
    
    /// キーボード高さの変更を購読するためのPublisher
    var publisher: AnyPublisher<CGFloat, Never> {
        subject.eraseToAnyPublisher()
    }
    
    private init() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillChangeFrameNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleKeyboardFrameChange(notification)
        }
    }
    
    private func handleKeyboardFrameChange(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        // キーボード高さを計算（画面下端からキーボード上端まで）
        let screenHeight = UIScreen.main.bounds.height
        let keyboardHeight = max(0, screenHeight - keyboardFrame.origin.y)
        
        subject.send(keyboardHeight)
    }
}
