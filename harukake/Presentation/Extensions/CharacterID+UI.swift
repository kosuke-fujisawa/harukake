//
//  CharacterID+UI.swift
//  harukake
//
//  Presentation層 - UI拡張
//  CharacterIDのUI専用プロパティとメソッド
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import Foundation

extension CharacterID {
    /// SDキャラクター用アセット画像名を取得（UI層の責務）
    var sdAssetImageName: String {
        switch self {
        case .hikari: return "sd_hikari"
        case .reina: return "sd_reina"
        case .mayu: return "sd_mayu"
        case .makoto: return "sd_makoto"
        case .daichi: return "sd_daichi"
        }
    }
    
    /// ミニキャラクター用アセット画像名を取得
    var miniAssetImageName: String {
        // SDキャラ名からmini用に変換
        return sdAssetImageName.replacingOccurrences(of: "sd_", with: "mini_")
    }
}
