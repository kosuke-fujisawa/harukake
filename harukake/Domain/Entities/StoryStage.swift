//
//  StoryStage.swift
//  harukake
//
//  This project is licensed under the CC BY-NC 4.0 license.
//  See the LICENSE file in the project root for full license information.
//
//  Non-commercial use only.
//

import Foundation

/// ストーリーの舞台状況を管理するドメインエンティティ
/// 背景、立ち絵配置、感情マークの現在状態を保持
struct StoryStage: Equatable {
    /// 現在の背景名
    var background: String
    /// 各位置の立ち絵情報
    var characters: [Position: CharacterDisplay]
    
    init(background: String = "default") {
        self.background = background
        self.characters = [:]
    }
    
    /// 立ち絵を表示・更新する
    mutating func showCharacter(_ name: String, at position: Position, expression: String) {
        characters[position] = CharacterDisplay(
            name: name, 
            expression: expression, 
            emote: characters[position]?.emote
        )
    }
    
    /// 立ち絵を非表示にする
    mutating func hideCharacter(_ name: String) {
        characters = characters.compactMapValues { display in
            display.name == name ? nil : display
        }
    }
    
    /// 立ち絵を移動する
    mutating func moveCharacter(_ name: String, to newPosition: Position) {
        // 移動元を探して削除
        var targetDisplay: CharacterDisplay?
        for (position, display) in characters {
            if display.name == name {
                targetDisplay = display
                characters[position] = nil
                break
            }
        }
        
        // 移動先に配置
        if let display = targetDisplay {
            characters[newPosition] = display
        }
    }
    
    /// 感情マークを表示する
    mutating func showEmote(for characterName: String, mark: String) {
        for (position, display) in characters {
            if display.name == characterName {
                characters[position] = CharacterDisplay(
                    name: display.name,
                    expression: display.expression,
                    emote: mark
                )
                break
            }
        }
    }
    
    /// 背景を変更する
    mutating func changeBackground(_ name: String) {
        background = name
    }
}

/// 立ち絵表示情報の値オブジェクト
struct CharacterDisplay: Equatable {
    let name: String
    let expression: String
    let emote: String?
    
    init(name: String, expression: String, emote: String? = nil) {
        self.name = name
        self.expression = expression
        self.emote = emote
    }
}