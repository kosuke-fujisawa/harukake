//
//  CharacterID.swift
//  harukake
//
//  Domain層 - ValueObject
//  キャラクターIDを表す値オブジェクト
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import Foundation

/// キャラクターIDを表す値オブジェクト
enum CharacterID: String, CaseIterable, Equatable, Hashable, Sendable {
    case hikari = "ひかり"
    case reina = "れいな"
    case mayu = "まゆ"
    case makoto = "誠"
    case daichi = "大地"

    /// 表示名を取得
    var displayName: String {
        return rawValue
    }
    
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
