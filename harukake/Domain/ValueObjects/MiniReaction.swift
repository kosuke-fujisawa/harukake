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

import Foundation

/// ミニキャラクター＋コメント表示用の値オブジェクト
struct MiniReaction: Equatable {
    /// 一言コメント
    let text: String
    /// キャラクターID（画像名はcharacterID.assetImageNameから取得）
    let characterID: CharacterID
    
    init(characterID: CharacterID, text: String) {
        self.characterID = characterID
        self.text = text
    }
}
