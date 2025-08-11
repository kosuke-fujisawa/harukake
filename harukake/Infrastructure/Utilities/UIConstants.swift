//
//  UIConstants.swift
//  harukake
//
//  このプロジェクトは CC BY-NC 4.0 ライセンスの下でライセンスされています。
//  プロジェクトルートのLICENSEファイルで完全なライセンス情報を参照してください。
//
//  非営利使用のみ。
//

import Foundation
import UIKit

/// アプリ全体で使用するUI定数を管理する構造体
struct UIConstants {
    
    // MARK: - レイアウト定数
    
    /// 下部メニューバーの高さ（72pt）
    static let bottomBarHeight: CGFloat = 72
    
    /// 標準的なパディング値
    static let standardPadding: CGFloat = 16
    
    /// SafeAreaに対する最小マージン
    static let minimumSafeAreaMargin: CGFloat = 12
    
    // MARK: - FAB（Floating Action Button）定数
    
    /// iPhone（通常）用FABサイズ
    static let fabSizeIPhoneStandard: CGFloat = 64
    
    /// iPhone（Plus/Max）用FABサイズ
    static let fabSizeIPhoneLarge: CGFloat = 68
    
    /// iPad用FABサイズ  
    static let fabSizeIPad: CGFloat = 80
    
    /// FABヒット領域の拡張値
    static let fabHitPadding: CGFloat = 12
    
    /// FAB下部バーとの間隔
    static let fabBottomBarSpacing: CGFloat = 8
    
    // MARK: - デバイス判定ヘルパー
    
    /// 現在のデバイスがiPadかどうか
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// 現在のデバイスが大型iPhone（Plus/Max系）かどうか
    /// 横幅896pt以上を基準とする（iPhone 14 Pro Max相当）
    static var isLargeIPhone: Bool {
        UIScreen.main.bounds.width >= 896
    }
    
    /// デバイスに応じた適切なFABサイズを取得
    static var appropriateFABSize: CGFloat {
        if isIPad {
            return fabSizeIPad
        } else if isLargeIPhone {
            return fabSizeIPhoneLarge  
        } else {
            return fabSizeIPhoneStandard
        }
    }
}
