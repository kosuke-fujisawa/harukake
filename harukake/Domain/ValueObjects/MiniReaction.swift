//
//  MiniReaction.swift
//  harukake
//
//  Domain層 - ValueObject
//  ミニキャラ＋コメント表示用の値オブジェクト
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import SwiftUI

/// ミニキャラクター＋コメント表示用の値オブジェクト
struct MiniReaction: Equatable {
    /// キャラクター画像名（Asset Catalogの画像名）
    let imageName: String
    /// 一言コメント
    let text: String
    /// キャラクターID（重複回避用）
    let characterID: CharacterID
    
    init(characterID: CharacterID, text: String) {
        self.characterID = characterID
        self.text = text
        self.imageName = "mini_\(characterID.rawValue)"
    }
}