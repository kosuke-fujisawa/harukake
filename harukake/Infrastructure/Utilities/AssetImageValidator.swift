//
//  AssetImageValidator.swift
//  harukake
//
//  Infrastructure層 - Utility
//  アセット画像の存在確認とフォールバック処理
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import SwiftUI

/// アセット画像の存在確認とフォールバック処理
struct AssetImageValidator {
    /// 指定された画像名のアセットが存在するかを確認
    /// - Parameter imageName: 確認する画像名
    /// - Returns: 画像が存在する場合はtrue
    static func imageExists(_ imageName: String) -> Bool {
        return UIImage(named: imageName) != nil
    }
    
    /// キャラクターIDに対応する安全な画像名を取得
    /// - Parameter characterID: キャラクターID
    /// - Returns: 存在する画像名、存在しない場合はフォールバック画像名
    static func safeImageName(for characterID: CharacterID) -> String {
        let imageName = characterID.assetImageName
        return imageExists(imageName) ? imageName : "sd_placeholder"
    }
}

extension CharacterID {
    /// アセット画像名を取得（SDキャラ用）
    var assetImageName: String {
        switch self {
        case .hikari: return "sd_hikari"
        case .reina: return "sd_reina"
        case .mayu: return "sd_mayu"
        case .makoto: return "sd_makoto"
        case .daichi: return "sd_daichi"
        }
    }
}
