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

/// キャラクターIDを表す値オブジェクト
enum CharacterID: String, CaseIterable, Sendable {
    case hikari = "ひかり"
    case reina = "れいな"
    case mayu = "まゆ"
    case makoto = "誠"
    case daichi = "大地"

    /// 表示名を取得
    var displayName: String {
        return rawValue
    }
}
