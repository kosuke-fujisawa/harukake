//
//  Comment.swift
//  harukake
//
//  Domain層 - Entity
//  キャラクターコメントのドメインエンティティ
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import Foundation

/// キャラクターコメントを表すドメインエンティティ
struct Comment: Equatable {
    let character: CharacterID
    let message: String
}
